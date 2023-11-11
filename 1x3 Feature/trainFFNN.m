% Load in the processed data, and feed it through a FFNN. Then output the 
% accuracy of the test results. (This doesn't represent true accuracy in
% deployment as there is no training/testing split)

sizeR = length(real);
sizeF = length(fake);

% Convert saved cell values into matrices
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

% Test the model's accuracy on this data
confusionchart(tab.Target, predict(model, X))
testAcc = 1-loss(model, tab)

