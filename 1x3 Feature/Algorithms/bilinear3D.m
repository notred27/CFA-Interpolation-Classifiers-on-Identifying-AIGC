function percentDiff = bilinear3D(img, src)
% bilinear3D: Return a 1x3 vector of RGB percent differences using bilinear interpolation
%   img: The "raw" approximation image of the image src
%   src: The original full color image to use in the percent difference
%           compairison

[w, h, ~] = size(img);
new = zeros(w,h,3);

% Define the green kernel (gf), and red and blue kernel (rbf) for this
% convolution
gf = [[0,0.25,0]; [0.25,1.0,0.25]; [0,0.25,0];];
rbf = [[0.25, 0.5, 0.25]; [0.5,1,0.5];[0.25, 0.5, 0.25];];

% Perform the convolution
for x = 2:w - 1
    for y = 2:h - 1
        gsum = 0.0;
        rsum = 0.0;
        bsum = 0.0;

        for u = 1:3
            for v = 1:3
                rsum = rsum + rbf(u,v) * double(img(x - u + 2, y - v + 2,1));
                gsum = gsum + gf(u,v) * double(img(x - u + 2, y - v + 2,2));
                bsum = bsum + rbf(u,v) * double(img(x - u + 2, y - v + 2,3));

            end
        end
        new(x,y,1) = rsum ;
        new(x,y,2) = gsum ;
        new(x,y,3) = bsum;
    end
end


% Calculate the percent difference between the reinterpolated image and the
% original image, and return the result
diff = uint8(src(2:w-1, 2:h-1, :)) - uint8(new(2:w-1, 2:h-1, :));
percentDiff = {double(sum(diff(:,:,1), "all")) / ((w-2) * (h-2)), double(sum(diff(:,:,2), "all")) / ((w-2) * (h-2))  , double(sum(diff(:,:,3), "all")) / ((w-2) * (h-2))};
end

