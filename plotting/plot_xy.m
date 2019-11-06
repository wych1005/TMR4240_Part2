function plot_xy(x, y, psi, t, vessel, scale, labels)
%
% plot_xy(x, y, psi, t, scale, labels)
%
%   x: x-position vector
%   y: y-position vector
%   psi: heading vector
%   t: time vector
%   vessel: true: Show vessel
%   scale: scaling used for boat visualization
%   labels: Optional: {'Title', 'Xlabel', 'Ylabel'}
%       defualt: {'NED-position', 'East [m]', 'North [m]'}
%
%
    boat_x = [-1 -1 1 1 0]; % Coordinates of the boat in x-axis
    boat_y = [1 -2 -2 1 2]; % Coordinates of the boat in y-axis
    boat_m = [boat_x; boat_y; ones(size(boat_x))]; % Boat coord. matrix
    
    % Color map setup
    numOfColors = numel(t);
    r = zeros(1, numOfColors);
    g = linspace(0.3, 1, numOfColors);
    b = zeros(1, numOfColors, 1);
    map = [r' g' b'];
    colormap(map)

    % Rotation matrix for boat visualization
    rotz = @(a, p) [cos(a) sin(a) p(2);
                    -sin(a)  cos(a) p(1);
                      0       0    1]; 

    if vessel
        boat_m_newPos = boat_m;
        for i = 1:ceil(length(x)/scale):length(x)
            angle = psi(i); %Y.data(i, 3);
            pos = [x(i) y(i)]; %Y.data(i, 1:2);

            % Rotate boat-corner coordinates
            for j = 1:size(boat_m, 2)
               boat_m_newPos(:, j) = rotz(angle, pos) * boat_m(:,j); 
            end

            boat = polyshape(boat_m_newPos(1, :), boat_m_newPos(2,:));  % Create the boat
%             plot(boat, 'FaceColor', 'blue', 'FaceAlpha', 0.05); hold on ;
            plot(boat, 'FaceColor', map(i, :), 'FaceAlpha', 1); hold on;
            %drawnow
            
            % Draw colorbar
            h = colorbar;
            caxis([t(1) t(end)]);
            yticklabels = get(h, 'YtickLabel');
            yticklabels = strcat(yticklabels, ' sec');
            set(h, 'YtickLabel', yticklabels);
        end
    end
    % Plot trajectory
    plot(y, x, 'r', 'linewidth', 2);
    drawnow
    hold off; grid on; box on;
    axis equal
    
    
    % Set labels if entered
    if nargin < 7
        labels = {'NED-position', 'East [m]', 'North [m]'};
    end
    title(labels{1});
    xlabel(labels{2}); ylabel(labels{3});
    

    set(gcf,'Position',[300 200 700 600])