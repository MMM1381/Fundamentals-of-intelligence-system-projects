% Parameters
b = 2; % Distance between the front and rear axles (wheelbase)
num_steps = 1000; % Number of steps in the simulation
step_size = -0.1; % Step size for backward movement (negative for backward)

% Initial conditions
x = 5; % Initial x position (start away from target)
y = 10; % Initial y position
phi = pi/6; % Initial orientation (in radians)

% Define fuzzy inference system (FIS)
fis = readfis('Car.fis');

% Simulation loop with fuzzy logic
figure;
hold on;
grid on;
axis equal;
title('Car Parking Simulation (Fuzzy Logic)');
xlabel('X Position');
ylabel('Y Position');

for t = 1:num_steps
    % Calculate inputs to the FIS
    distance_to_target = 10 - x; % Target x = 10 (can be negative or positive)
    
    % Correct phi to be in the range [0, 2*pi]
    phi_corrected = 0;
    if phi > 0    
        phi_corrected = mod(phi, 2*pi);
    else
        phi_corrected = 2*pi - mod(abs(phi), 2*pi);
    end
     
    % Evaluate fuzzy logic
    theta = evalfis(fis, [distance_to_target, phi_corrected]); % Steering angle

    % Update the car's position and orientation using corrected formulas
    x = x + step_size * cos(phi);
    y = y + step_size * sin(phi);
    phi = phi + step_size * tan(theta) / b;

    % Plot the current position and orientation
    quiver(x, y, cos(phi), sin(phi), 0.5, 'r');
    plot(x, y, 'bo');
    pause(0.001); % Pause to simulate real-time plotting
end

% writeFIS(fis, 'CarParking.fis');

hold off;
