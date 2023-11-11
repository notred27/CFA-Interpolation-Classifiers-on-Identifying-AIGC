% File for testing images using trained models (based on the 1x3 feature)
addpath '1x3 Feature\Algorithms'
addpath '1x3 Feature\Sample Data'

% Set parameters here   
pattern = 'gbrg';   % The Bayer array configuration the reinterpolation algorithms should use
img_src = '';
model_src = "Sample Data\sample_diverse_model.mat";


% Find the 1x3 percent difference feature for each of the algorithms
algos = ["bilinear", "bicubic", "smoothHue", "gradient"];
percent_diff = cell(4,1);
sum = zeros(4,1);

[R,G,B] = bayers(pattern);

img = imread(img_src);

for i = 1:length(algos)
    percent_diff{i} = reinterp3D(img, pattern,algos(i), R,G,B);
    sum(i) = percent_diff{i}{1} + percent_diff{i}{2} + percent_diff{i}{3};
end

% Find the feature with the minimum total percent difference
best_algo = find(sum == min(sum));
feature = [cell2mat(percent_diff{best_algo}(1:3))]

% Test this feature against our model, and output a decision
model = load(model_src).best_model;
if predict(model, feature) == 1
    result = "Image is real."
else
    result = "Image is fake."
end

