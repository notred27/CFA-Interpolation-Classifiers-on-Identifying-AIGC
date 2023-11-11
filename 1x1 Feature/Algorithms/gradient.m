function percentDiff = gradient(img, src, pattern)
% gradient: Return a 1x3 vector of RGB percent differences using MATLAB's
% gradient-corrected linear interpolation
%   img: The "raw" approximation image of the image src
%   src: The original full color image to use in the percent difference
%           compairison
%   pattern: the arrangement of bayer arrays that was used
%
%   See also bayers

[width,height] = size(img);

% Use MATLAB's built in gradient-corrected linear interpolation algorithm
% to reinterpolate the image
demosaiced = uint8(demosaic(uint8(img), pattern));


% Calculate the percent difference between the reinterpolated image and the
% original image, and return the result
bayerDiff = uint8(src) - demosaiced; 

fSum = 0.0;
for i = 1:width
    for j = 1:height
        % Pixel wise
         fSum = fSum + (double(bayerDiff(i,j,1)) + double(bayerDiff(i,j,2)) + double(bayerDiff(i,j,3)));
    end
end

percentDiff = fSum / (width * height);
end

