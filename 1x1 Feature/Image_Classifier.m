% File for testing images using trained models (based on the 1x1 feature)
addpath 'Algorithms'

% Set parameters here   
pattern = 'gbrg';   % The Bayer array configuration the reinterpolation algorithms should use
img_src = '';
threshold = 1.3399; % This was the value used in the paper found based on a sparce dataset

% Find the 1x3 percent difference feature for each of the algorithms
algos = ["bilinear", "bicubic", "smoothHue", "gradient"];
percent_diff = cell(4,1);
sum = zeros(4,1);

[R,G,B] = bayers(pattern);

img = imread(img_src);

fprintf("Testing Image: (%s) on 1x1 Feature\n", img_src)
for i = 1:length(algos)
    percent_diff = reinterp(img, pattern,algos(i), R,G,B);

    if percent_diff <= threshold
        fprintf("  Image is real with algorithm %s (image val: %f)\n", algos(i), percent_diff)
    else 
        fprintf("  Image is fake with algorithm %s (image val: %f)\n", algos(i), percent_diff)
    end

end




