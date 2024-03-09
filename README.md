# CFA-Interpolation-Classifiers-on-Identifying-AIGC
Code repository that was used when creating the paper titled "Investigating the Effectiveness of Deep Learning and CFA Interpolation Based Classifiers on Identifying AIGC" by Micahel Reidy,
Henry Mallon, and Jiebo Luo. This repository contains classifers that are able to distinguish between AI-generated images (so called AIGC) and genuinely captured images by CFA percent error techniques.
$F^1$ is a 1-dimensional feature that is used in thresholding classifiers, while $F^2$ is a 3-dimensional feature to be used in neural network classifiers.

To test an image on pretrained classifiers, enter either feature repository, and run Image_Classifier.m after updating the variable img_src to the test image's path. After running the file, the feature and classification descision will be printed to the console. 

The full paper can be found on [IEEE Xplore](https://ieeexplore.ieee.org/document/10386096)
