
function [percentDiff] = reinterp3D(img, pattern, algo, R,G,B)
% reinterp3D: Return a 1x3 vector of RGB percent differences (between a source image and its reinterpolated image) using the specified interpolation algorithm
%   img: A full color image (in the form of a matrix)
%   pattern: the arrangement of bayer arrays that was used
%   algo: the specified interpolation algorithm to use {bilinear, bicubic, smoothHue, gradient}
%   R: the red mask from the specified bayer configuration
%   G: the green mask from the specified bayer configuration
%   B: the blue mask from the specified bayer configuration
%
%   See also bayers, bilinear3D, bicubic3D, smoothHue3D, gradient3D

img = double(img);
[width, height, ~] = size(img);

%Resize Image so border collisions don't occur
wOff = mod(width, 4);
hOff = mod(height, 4);

if(wOff ~= 0 && hOff ~= 0)
    img = double(img(1:(width - wOff),1:(height - hOff), :));
end

% Get new image size (for padding)
width = width - wOff;
height = height - hOff;

% Create matrices that represent the "raw" aproximation of the source images
% RGB channels (based on the gicen bayer array configuration)
red = zeros(width, height);
green = zeros(width, height);
blue = zeros(width, height);

bayer = zeros(width,height);
for x = 1:2:(width)
    for y = 1:2:(height)
        % Get current 2x2 block in the image
        block = img(x:x+1,y:y+1,:);
        % Apply the bayer filter
        bayer(x:x+1,y:y+1) = block(:,:,1).* R + block(:,:,2).* G + block(:,:,3).* B;

        red(x:x+1,y:y+1) = block(:,:,1).* R;
        green(x:x+1,y:y+1) =block(:,:,2).* G;
        blue(x:x+1,y:y+1) = block(:,:,3).* B;

    end
end


% Reshape into a 3D color image for the 3D interpolation methods
ThreeD_Bayer = [red, green, blue];
ThreeD_Bayer = reshape(ThreeD_Bayer, [width, height, 3]);

% Find the percent difference between th eoriginal image and reinterpolated
% image using the specified algorithm

% Using bilinear interpolation
if strcmp(algo, "bilinear")
    percentDiff = bilinear3D(ThreeD_Bayer, uint8(img));
end

% Using bicubic interpolation
if strcmp(algo, "bicubic")
    percentDiff = bicubic3D(ThreeD_Bayer, uint8(img));
end

% Using smooth hue interpolation
if strcmp(algo, "smoothHue")
    percentDiff = smoothHue3D(ThreeD_Bayer, uint8(img));
end

% Using MATLAB's using gradient-corrected linear interpolation algo
if strcmp(algo, "gradient")
    percentDiff = gradient3D(bayer, img, pattern);
end

end