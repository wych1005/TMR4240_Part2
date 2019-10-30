clear variables; clc;

% Thruster configuration matrix, extended and non-extended
ue_to_t_ = [-1/sqrt(2) 1 0   1    0  1/sqrt(2);
            -1/sqrt(2) 0 1   0    1 -1/sqrt(2);
                     0 2 0.5 2 -0.5          0 ];

u_to_t_ = @(a) [-1/sqrt(2)               sin(a(1))               sin(a(2))  1/sqrt(2);
                -1/sqrt(2)               cos(a(1))               cos(a(2)) -1/sqrt(2);
                         0 2*sin(a(1))+cos(a(1))/2 2*sin(a(2))-cos(a(2))/2          0 ];

% thrusters weights
We_ = diag([1 1 1 1 1 1]);
W_ = diag([1 1 1 1]);

% Constraints
thrustLimits = [25; 60; 60; 25];
throttleLimits = [4; 8; 8; 4];
angleRateLimits = [0.3; 0.3];

% desired force & torque
t_des = [15; 60; -20];

% initial thrust and angle
u_prev = [0; 0; 0; 0];
a_prev = [0; 0];

% some other needed variables
u_indices = [1; 2; 3; 4];
a_indices = [2; 3];

azimuth.mask = [false; true; true; false];
azimuth.u_to_ue_index = [1; 2; 4; 6];
azimuth.u_to_a_index = [-1; 1; 1; -1];


%%
disp('################## ############ ##################')
disp('################ Allocation Start ################')

% variables that hold which thrusters are and are not considered in the
% current iteration.
u_use = [true; true; true; true];
a_use = [true; true];

u_des = u_prev;
a_des = a_prev;

t_des_subset = t_des;

iter = 0;
feasible = false;
% feasible if all thrust and rate constraints are satisfied
while ~feasible
    
    iter = iter + 1;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Assemble configuration matrix
    % (weight matrix W is tbd.)
    disp(['################## Iteration: ' num2str(iter) ' ##################'])
    disp(['Using Thrusters subset: ' num2str(u_use') ' | indices: ' num2str(u_indices(u_use)')])
    
    ue_to_t = [];
    
    % iterate through assignable thrusters
    k = 0;
    for i = u_indices(u_use)'    
        % check if current thruster is azimuth or fixed
        
        if azimuth.mask(i) % azimuth thruster
            
            j = azimuth.u_to_ue_index(i);
            
            % check if angle is constrained or assignable
            if a_use(azimuth.u_to_a_index(i)) % assignable
                ue_to_t = [ue_to_t ue_to_t_(:, j:(j+1))];
            else % constrained
                u_to_t = u_to_t_(a_actual);
                ue_to_t = [ue_to_t u_to_t(:, j)];
            end
            k = k + 2;
        else % fixed thruster
            j = azimuth.u_to_ue_index(i);
            ue_to_t = [ue_to_t ue_to_t_(:, j)];
            k = k + 1;
        end
    end
    
    W = eye(k);
    disp('Configuration matrix:')
    disp(num2str(ue_to_t))
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Calc desired extended thruster force
    
    sz = size(ue_to_t);
    if sz(1) <= sz(2)
        %disp('a');
        t_to_ue = (W \ ue_to_t') / (ue_to_t * (W \ ue_to_t'));
    else
        %disp('b');
        % t_to_ue = (ue_to_t' * (W \ ue_to_t)) \ (ue_to_t' / W);
        t_to_ue = (ue_to_t' * ue_to_t) \ ue_to_t';
    end
    
    ue_des = t_to_ue * t_des_subset;
    
    disp('Calculated extended thruster forces subset:');
    disp(num2str(ue_des'));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % convert to non extended u and angle
    k = 1;
    j = 1;
    for i = u_indices(u_use)'
        %disp(['i: ' num2str(i)])
        if azimuth.mask(i) % azimuth thruster
            tmp = sqrt(ue_des(j)^2 + ue_des(j+1)^2);
            u_des(i) = tmp;
            a_des(k) = atan2(ue_des(j), ue_des(j+1));
            k = k + 1;
            j = j + 2;
        else % fixed thruster
            % j = azimuth.u_to_ue_index(i);
            % disp(['f: ' num2str(j)])
            u_des(i) = ue_des(j);
            j = j + 1;
        end
    end
    
    
    disp('Overall non-extended thruster forces:')
    disp(['<strong>' num2str(u_des') '</strong>']);
    disp(['Angles: <strong>' num2str(a_des') '</strong>']);
    disp('-------------------------------------------')
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % checking thrust rate saturation limits
    u_change = u_des - u_prev;
    u_change_abs = abs(u_change);
    u_change_sign = sign(u_change);
    u_rate_violations = u_change_abs > throttleLimits;
    disp(['Thrusters that violated rate contraints: ' num2str(u_rate_violations') ' | ' num2str(u_indices(u_rate_violations)')]);
    
    % keep components that do not violate
    u_des_rate_sat = u_prev + u_change .* (~u_rate_violations);
    
    % constrain components that do.
    u_des_rate_sat = u_des_rate_sat + throttleLimits .* u_change_sign .* u_rate_violations;
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % checking magnitude saturation limits
    u_des_rate_sat_mag = abs(u_des_rate_sat);
    u_des_rate_sat_sign = sign(u_des_rate_sat);
    
    u_thrust_violations = u_des_rate_sat_mag > thrustLimits;
    disp(['Thrusters that violated mag contraints: ' num2str(u_thrust_violations') ' | ' num2str(u_indices(u_thrust_violations)')]);
    
    % keep components that do not violate    
    u_des_sat = u_des_rate_sat .* (~u_thrust_violations);
    
    % constrain components that do.
    u_des_sat = u_des_sat + + thrustLimits .* u_des_rate_sat_sign .* u_thrust_violations;
    disp(['Saturated thruster forces: <strong>' num2str(u_des_sat') '</strong>']);
    u_des = u_des_sat;
    
    u_violations = u_rate_violations | u_thrust_violations;
    u_actual(u_violations) = u_des_sat(u_violations);
    u_use = u_use & (~u_violations);
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % checking angle rate saturation limits
    a_change = a_des - a_prev;
    a_change_abs = abs(a_change);
    a_change_sign = sign(a_change);
    
    a_rate_violations = a_change_abs > angleRateLimits;
    disp(['Angles that violated rate contraints: ' num2str(a_rate_violations') ' | ' num2str(a_indices(a_rate_violations)')]);
    
    % keep components that do not violate
    a_des_rate_sat = a_prev + a_change .* (~a_rate_violations);
    
    % constrain components that do.
    a_des_rate_sat = a_des_rate_sat + angleRateLimits .* a_change_sign .* a_rate_violations;
    disp(['Saturated thruster angles: <strong>' num2str(a_des_rate_sat') '</strong>']);
    disp('-------------------------------------------')
    
    a_des = a_des_rate_sat;
    
    
    % check if a violating thruster is an azimuth thruster, if so, also
    % contrain the angle
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Calculate the contribution of the constrained thruster forces to the
    % desired overall force.
    
    disp('Removing the force contribution of the constrained')
    disp('thrusters from the desired force');
    u_to_t = u_to_t_(a_des);
    disp(num2str(u_to_t(:,u_violations)))
    
    t_con = u_to_t(:,u_violations)*u_des_sat(u_violations);
    disp(['Contribution: ' num2str(t_con')])
    disp(['t_des old: ' num2str(t_des_subset')])
    t_des_subset = t_des_subset - t_con;
    disp(['t_des new: ' num2str(t_des_subset')])
    
    
    
    % if all are constrained => terminate
    % if none violate limits => terminate
    
    % if isempty(find(u_use, 1)) && isempty(find(a_use, 1))
    if isempty(find(u_use, 1))
        % all are constrained
        feasible = true;
        disp('All thrusters are constrained. Terminating');
    end
    
    if isempty(find(a_rate_violations, true)) && isempty(find(u_violations, true))
        % no contraint/limit violations this iteration
        feasible = true;
        disp('No limits are violated. Terminating');
    end
    

%     if iter > 2
%         feasible = true;
%     end


    %feasible = true;
end

disp('################# Allocation End #################')
disp('################## ############ ##################')
disp(['Desired Force: <strong>' num2str(t_des') '</strong>'])
disp(['Actual force: <strong>' num2str((u_to_t_(a_des)*u_des)') '</strong>'])

u_prev = u_des;
a_prev = a_des;




















%%


% why do we need thrust allocation that is more complex than just a 
% pseudoinverse? the thrusters are rate and magnutude constrained anyway, 
% so there is nothing we can do here and we should just have a constroller
% that is slow enough so that no rate limits are violated.

% Answer: we can get extra performance out of the system using this smart
% allocation, if there is a redundtant thruster configuration. It is often
% the case that a desired force results in some thrusters to be limited and
% the other not, so one should allocate more force onto the thrusters that
% are not. This is what this algorithm does.