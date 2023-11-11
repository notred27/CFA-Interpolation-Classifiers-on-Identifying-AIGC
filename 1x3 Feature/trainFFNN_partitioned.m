% Load in the processed data, divide into training and testing sets, and
% feed it through a FFNN. Then output the accuracy of the test results on
% the tesing dataset.

real_directories = ["C:\Users\miker\Desktop\CFA Paper\CFA_Forgery\Image-forgery-localisation-via-fine-grained-analysis-of-CFA-artifacts-main\CAT DOG results\", "C:\Users\miker\Desktop\CFA Paper\CFA_Forgery\Image-forgery-localisation-via-fine-grained-analysis-of-CFA-artifacts-main\1.2k Faces Results\", "C:\Users\miker\Desktop\CFA Paper\CFA_Forgery\Image-forgery-localisation-via-fine-grained-analysis-of-CFA-artifacts-main\2k Faces Results\"];
fake_directories = ["C:\Users\miker\Desktop\CFA Paper\CFA_Forgery\Image-forgery-localisation-via-fine-grained-analysis-of-CFA-artifacts-main\CAT DOG results\", "C:\Users\miker\Desktop\CFA Paper\CFA_Forgery\Image-forgery-localisation-via-fine-grained-analysis-of-CFA-artifacts-main\1.2k Faces Results\", "C:\Users\miker\Desktop\CFA Paper\CFA_Forgery\Image-forgery-localisation-via-fine-grained-analysis-of-CFA-artifacts-main\2k Faces Results\"];

% Separate into 80:20 split for training and testing
training_percent = 0.8;

% Define the bayer array that the data used
bayer = 'gbrg';


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


% Convert saved cell values into matrices
sizeR= length(real);
sizeF = length(fake);

R = zeros(sizeR, 3);
for i = 1:sizeR
    R(i, :) = cell2mat(real{i});
end

F = zeros(sizeF, 3);
for i = 1:sizeF
    F(i, :) = cell2mat(fake{i});
end

% Convert data into something the FFNN can process
X = [R;F];
targ = zeros((sizeR+ sizeF),1);
targ(1:sizeR) = 1;
% 1 is real, 0 is fake

R_Channel = X(:, 1);
G_Channel = X(:, 2);
B_Channel = X(:, 3);

tab = table(R_Channel, G_Channel, B_Channel, targ);
tab.Properties.VariableNames = {'R_Channel','G_Channel','B_Channel', 'Target'};

% Train the Feed-Forward Neural Network
model = fitcnet(tab, "Target", "LayerSizes",[18,6,12,6]);

% Create new arrays to test accuracy on the testing dataset
sizeR= length(real_test);
sizeF = length(fake_test);

R = zeros(sizeR, 3);
for i = 1:sizeR
    R(i, :) = cell2mat(real_test{i});

end

F = zeros(sizeF, 3);
for i = 1:sizeF
    F(i, :) = cell2mat(fake_test{i});

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

% Test the model's accuracy on the testing dataset
confusionchart(tab.Target, predict(model, X))
testAcc = 1-loss(model, tab)

