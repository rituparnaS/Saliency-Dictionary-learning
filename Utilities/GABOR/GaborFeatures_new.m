%----------------------------------------------------------------------
% This function attempts to merge everything in extract_brodatz.m into
% one place
% 
%           I : Grayscale image to extract features from.  Image must be
%               whose widths are powers of 2
%       stage : specify which gabor filter is selected.
%               Determines how many frequency levels (paper uses 4)
% orientation : specify which gabor filter is selected.
%               Determines how many directions (paper uses 6)
%          Ul : specify the minimum center frequency (paper uses 0.05)
%          Uh : specify the maximum center frequency (paper uses 0.4)
%        flag : 1 -> remove the dc value of the real part of Gabor
%               0 -> not to remove
%               (paper uses 0)
%        mask : (optional) bit mask to determine which pixels to use
%
% The feature vector is a matrix containing 1 row for each stage and
% orientation pair and 2 columns for mean and variance of that filter
% response
%
% Paper: Texture Features for Browsing and Retrieval of Image Data
%
%----------------------------------------------------------------------
function[F,D] = GaborFeatures_new(I, stage, orientation, Ul, Uh, flag, varargin)

%NOTE: image is assumed to be square with width being a power of 2
[height,width] = size(I);
% N = max(height,width);
N = height;
M = width;

freq = [Ul, Uh];
j = sqrt(-1);
GW = {};

% --------------- generate the Gabor FFT data ---------------------
for s = 1:stage,
    for n = 1:orientation,
        [Gr,Gi] = Gabor(N,M,[s n],freq,[stage orientation],flag);
        %F = fft2(Gr+j*Gi);
        F = (Gr+j*Gi);
        F(1,1) = 0;
        GW{s,n} = F;
    end;
end;
GW;
% ------------------ Extract the features -------------------------
if length(varargin) > 0;
    mask = varargin{1};
    [F,D] = Fea_Gabor_brodatz_new(I, GW, stage, orientation, mask);
else
    [F,D] = Fea_Gabor_brodatz_new(I, GW, stage, orientation);
end
