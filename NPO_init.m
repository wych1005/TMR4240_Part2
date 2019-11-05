disp('NPO Init');
% EKF_init; % Required for the wave model

% Tuning values
w_o = 2*pi/9; % Wave peak frequency
lambda = 0.1;
w_c = 1.2* w_o; % Filter cut off

T = diag([1000 1000 1000]); % Bias time constants

% Bias gains
K_4 = 100000*diag([1 1 100]);
K_3 = 0.1 * K_4;



K_1i = -2*(1-lambda) * w_c/w_o;
K_1i3 = 2*(1-lambda) * w_o;
K_2i = w_c;

K_1 = [diag([K_1i K_1i K_1i]);
       diag([K_1i3 K_1i3 K_1i3])];
   
K_2 = K_2i * eye(3);


% Ensure passivity
if w_o > w_c; error('NPO requires w_0 < w_c'); end
if any(diag(K_3/K_4) > w_o); error('NPO requires K_3/K_4 > w_c'); end
if any(1./diag(T) > diag(K_3/K_4)); error('NPO requires 1/T < K_3/K_4'); end


% if false
%     figure
%     w = logspace(-4,1.5,100);   
%     
%     i = 1;  % 1 = surge, 2 = sway, 3 = yaw
%     h0 = tf( [1 2 * lambda*w_o w_o*w_o],...
%         [1 (K_1(2, i)+K_2(i,i)+2*lambda*w_o)...
%         (w_o^2+2*lambda*w_o*K_2(i,i)-K_1(i,i)*w_o^2)...
%         w_o^2*K_2(i,i)] );
%     
%     hB = tf(K_4(i,i)*[1 (1/T(i,i)+K_3(i,i)/K_4(i,i))],[1 1/T(i,i)]);
%     wave = tf([w_o^2 0],[1 2*lambda*w_o w_o^2]);      % wave response spectrum
% 
%     bode(series(h0,hB), wave, w); grid on
%     legend('Filter', 'Wave')
% end