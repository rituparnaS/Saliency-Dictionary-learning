Install VLfeat and add that to the Matlab path. If you are using other functions for 
superpixel/saliency please replace the respective code

1. Main_SDL.m

File for creating directories, superpixel, gabor features for each superpixel, image saliency

a. function parallelGabor: Computes the Gabor features for each superpixel
(If you do not with to compute Gabor features for your image, 
save the image features in as mat files int he corresponding 
location and input it to the dictioanry learning function 


b. function computeparallelGdict: Computes the saliency dictionary learning 

2. compute_similarity.m

This file computes the similarity between images, It inouts the dictioanry 
and sparse codes for each image stored as mat file and compares the sparse histogram 
