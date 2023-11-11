function percentDiff = bicubic(img,src)
% bicubic: Return a double that represents the sum of RGB percent differences using bicubic interpolation
%   img: The "raw" approximation image of the image src
%   src: The original full color image to use in the percent difference
%           compairison

[w, h, ~] = size(img);
new = zeros(w,h,3);

% Define the green kernel (gf), and red and blue kernel (rbf) for this
% convolution
gf = [[0,0,0,1,0,0,0];[0,0,-9,0,-9,0,0];[0,-9,0,81,0,-9,0];[1,0,81,256,81,0,1];[0,-9,0,81,0,-9,0];[0,0,-9,0,-9,0,0];[0,0,0,1,0,0,0];] * (1/256);
rbf = [[1/256, 0, -9/256, -1/16, -9/256, 0, 1/256];[0,0,0,0,0,0,0];[-9/256, 0, 81/256, 9/16, 81/256, 0, -9/256];[-1/16, 0, 9/16, 1, 9/16, 0, -1/16];[-9/256, 0, 81/256, 9/16, 81/256, 0, -9/256];[0,0,0,0,0,0,0];[1/256, 0, -9/256, -1/16, -9/256, 0, 1/256];];

% Perform the convolution
for x = 8:w - 7
    for y = 8:h - 7
        gsum = 0.0;
        rsum = 0.0;
        bsum = 0.0;

        for u = 1:7
            for v = 1:7
                rsum = rsum + rbf(u,v) * double(img(x - u + 4, y - v + 4,1));
                gsum = gsum + gf(u,v) * double(img(x - u + 4, y - v + 4,2));
                bsum = bsum + rbf(u,v) * double(img(x - u + 4, y - v + 4,3));

            end
        end
        new(x,y,1) = rsum ;
        new(x,y,2) = gsum ;
        new(x,y,3) = bsum;
    end
end

% Calculate the percent difference between the reinterpolated image and the
% original image, and return the result
diff = uint8(src(8:w-7, 8:h-7, :)) - uint8(new(8:w-7, 8:h-7, :));
res = diff(:,:,1) + diff(:,:,2) + diff(:,:,2);
percentDiff = double(sum(res, "all")) / ((w-14) * (h-14));
end

