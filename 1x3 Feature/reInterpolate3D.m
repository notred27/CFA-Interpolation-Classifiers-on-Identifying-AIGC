% Script that generates 1x3 vectors for the CFA Percent Difference Classifier

% Check to ensure the files you are processing are using the correct image
% extension (lines 25 and 33)

% Filepaths of the source directories that contain the genuine and AIGC images
fakeSrc =  "C:\Users\miker\Desktop\cat_dog\fake\"; %"C:\Users\miker\Desktop\cat_dog\fake\";
realSrc = "C:\Users\miker\Desktop\cat_dog\real_cropped\"; %"C:\Users\miker\Desktop\cat_dog\real\";

% Specify the interpolation algorithm, bayer arrangement, and destination
% for the files
algo = "smoothHue";
pattern = 'rggb';
dst = "CAT DOG results";

% Set the max number of images to process
max_num = 1000;

% Obtain the Bayer array masks
[R,G,B] = bayers(pattern);

% Find the percent difference for the fake (AIGC) images
files=dir(fullfile(fakeSrc, '*.jpg'));
fake = cell(min(length(files), max_num),1);
for i=1:min(length(files), max_num)
    img = imread(string(fakeSrc) + files(i).name);
    fake{i} =  reinterp3D(img, pattern,algo, R,G,B);
end

% Find the percent difference for the real (genuine) images
files=dir(fullfile(realSrc, '*.jpg'));
real = cell(min(length(files), max_num),1);
for i=1:min(length(files), max_num)
    img = imread(string(realSrc) + files(i).name);
    real{i} =  reinterp3D(img, pattern,algo, R,G,B);
end

% Save the variables that contain the 1x3 vectors from the experiment
save(join([dst, "\", pattern, '\r_', algo,'3D_',pattern,'.mat'],''), "real")
save(join([dst, "\",pattern, '\f_',algo, '_',pattern ,'.mat'],''), "fake")
