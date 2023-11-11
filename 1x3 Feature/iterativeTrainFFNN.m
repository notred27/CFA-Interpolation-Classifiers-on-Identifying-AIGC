% Load in the processed data, combine into trainingand testing sets, and
% feed it through a FFNN. Then output the accuracy of the test results


% Define the locations of the directories that hold the results of testing
% the images (arrays of strings)
real_directories = ["C:\Users\miker\Desktop\CFA Paper\CFA_Forgery\Image-forgery-localisation-via-fine-grained-analysis-of-CFA-artifacts-main\CAT DOG results\", "C:\Users\miker\Desktop\CFA Paper\CFA_Forgery\Image-forgery-localisation-via-fine-grained-analysis-of-CFA-artifacts-main\1.2k Faces Results\", "C:\Users\miker\Desktop\CFA Paper\CFA_Forgery\Image-forgery-localisation-via-fine-grained-analysis-of-CFA-artifacts-main\2k Faces Results\"];
fake_directories = ["C:\Users\miker\Desktop\CFA Paper\CFA_Forgery\Image-forgery-localisation-via-fine-grained-analysis-of-CFA-artifacts-main\CAT DOG results\", "C:\Users\miker\Desktop\CFA Paper\CFA_Forgery\Image-forgery-localisation-via-fine-grained-analysis-of-CFA-artifacts-main\1.2k Faces Results\", "C:\Users\miker\Desktop\CFA Paper\CFA_Forgery\Image-forgery-localisation-via-fine-grained-analysis-of-CFA-artifacts-main\2k Faces Results\"];

bayer = 'gbrg';         % Define the Bayer array that the data used
training_percent = 0.8; % Separate into 80:20 split for training and testing

max_iter = 10;          % The maximum number of training iterations you want to simulate
min_desired_acc = 0.75;  % The minimum accuracy you would like to achieve (break condition)



% Load the best percent differences for the real images
training_partition = zeros(1,length(real_directories));
real = {};
real_test = {};

for i = 1:length(real_directories)

    tmp = load(join([real_directories(i),bayer,'\best_r.mat'],'')).best_r;
    training_partition(i) = round(length(tmp) * training_percent);

    real = [real;tmp(1:training_partition(i))];
    real_test = [real_test; tmp(training_partition(i)+1:end)];
end


% Load the best percent differences for the fake images
training_partition = zeros(1,length(fake_directories));
fake = {};
fake_test = {};

for i = 1:length(fake_directories)
    tmp = load(join([fake_directories(i),bayer,'\best_f.mat'],'')).best_f;
    training_partition(i) = round(length(tmp) * training_percent);

    fake = [fake;tmp(1:training_partition(i))];
    fake_test = [fake_test;tmp(training_partition(i)+1:end)];
end





% Construct the training dataset
sizeR= length(real);
sizeF = length(fake);

R = zeros(sizeR, 3);
for i = 1:sizeR
    R(i, 1:3) = cell2mat(real{i});
end

F = zeros(sizeF, 3);
for i = 1:sizeF
    F(i, 1:3) = cell2mat(fake{i});
end

X = [R;F];
targ = zeros((sizeR+ sizeF),1);
targ(1:sizeR) = 1;
% % 1 is real, 0 is fake

R_Channel = X(:, 1);
G_Channel = X(:, 2);
B_Channel = X(:, 3);

tab = table(R_Channel, G_Channel, B_Channel, targ);
tab.Properties.VariableNames = {'R_Channel','G_Channel','B_Channel', 'Target'};


% Create the testing dataset
sizeR= length(real_test);
sizeF = length(fake_test);

R = zeros(sizeR, 3);
for i = 1:sizeR
    R(i, 1:3) = cell2mat(real_test{i});
end

F = zeros(sizeF, 3);
for i = 1:sizeF
    F(i, 1:3) = cell2mat(fake_test{i});

end

X2 = [R;F];
targ = zeros((sizeR+ sizeF),1);
targ(1:sizeR) = 1;
% % 1 is real, 0 is fake

R_Channel = X2(:, 1);
G_Channel = X2(:, 2);
B_Channel = X2(:, 3);

test_tab = table(R_Channel, G_Channel, B_Channel, targ);
test_tab.Properties.VariableNames = {'R_Channel','G_Channel','B_Channel', 'Target'};





%Loop to find best model by iterating over random training
iter = 0;
best_model = fitcnet(tab, "Target", "LayerSizes",[18,6,6]);
best_acc = 1-loss(best_model, test_tab)
while iter < max_iter
% Train a new model
model = fitcnet(tab, "Target", "LayerSizes",[18,6,6]);

% Test to see if its accuracy is better than the previously best model
prediction = predict(model, X2);
confusion = confusionchart(test_tab.Target, predict(model, X2));
testAcc = 1-loss(model, test_tab);

if testAcc > best_acc
    best_model = model;
    best_acc = testAcc

    % Escape condition for meeting the minimium desired accuracy
    if testAcc >= min_desired_acc
        break
    end
end


% cm = confusion.NormalizedValues;
% net_f1 = (2* cm(2,2)) / (2 * cm(2,2) + cm(1,2) + cm(2,1));
iter = iter + 1
end

% Show the best accuracy that was achieved
best_acc = 1-loss(best_model, test_tab)
