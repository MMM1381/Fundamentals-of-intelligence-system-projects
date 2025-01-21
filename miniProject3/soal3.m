% Load the ball and beam dataset
data = readtable('ballbeam.dat');

x = data{:, 1}; % First column as input
y = data{:, 2}; % Second column as output

% Normalize data (optional, depending on your dataset)
x = (x - min(x)) / (max(x) - min(x)); % Normalize input
y = (y - min(y)) / (max(y) - min(y)); % Normalize output

% Split the data into training and testing sets
split_ratio = 0.8; % 80% training, 20% testing
num_train = floor(split_ratio * length(x)); % Number of training samples

% Shuffle the data
rng(73); % Set seed for reproducibility
indices = randperm(length(x)); % Random permutation of indices
train_indices = indices(1:num_train); % Training indices
test_indices = indices(num_train+1:end); % Testing indices

% Create training and testing sets
x_train = x(train_indices);
y_train = y(train_indices);
x_test = x(test_indices);
y_test = y(test_indices);

% Generating ANFIS network option objects
opt = genfisOptions('GridPartition');
opt.NumMembershipFunctions = 3; % Set number of membership functions
opt.InputMembershipFunctionType = 'gbellmf'; % Generalized bell-shaped MF

% Generate initial FIS
infis = genfis(x_train, y_train, opt);

% Training the ANFIS
train_data = [x_train, y_train]; % Combine input and output for training
opt_train = anfisOptions('InitialFis', infis, 'EpochNumber', 100);
mynetwork = anfis(train_data, opt_train);

% Prediction
y_pred_train = evalfis(mynetwork, x_train); % Predict on training data
y_pred_test = evalfis(mynetwork, x_test);   % Predict on testing data

% Calculate performance metrics
mse_train = mean((y_train - y_pred_train).^2); % MSE for training
mse_test = mean((y_test - y_pred_test).^2);   % MSE for testing

% Display performance metrics
fprintf('MSE (Train): %.4f\n', mse_train);
fprintf('MSE (Test): %.4f\n', mse_test);

% Plot results
figure;
hold on;
plot( y_train, 'b', 'DisplayName', 'Training Data'); % Training data
plot(y_pred_train, 'r', 'DisplayName', 'Predicted (Train)'); % Predicted train
xlabel('Input');
ylabel('Output');
title('Train ANFIS Results for Ball and Beam');

figure;
hold on;
plot(y_pred_test, 'm', 'DisplayName', 'Predicted (Test)');    % Predicted test
plot(y_test, 'g', 'DisplayName', 'Testing Data');    % Testing data
legend;
xlabel('Input');
ylabel('Output');
title('Test ANFIS Results for Ball and Beam');
hold off;

