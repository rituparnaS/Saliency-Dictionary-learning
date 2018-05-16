% -----------------------------------------------------------------
% This function compute the image features for each Gabor filter
% output, it is used for PAMI paper.
% -----------------------------------------------------------------

function [F,D] = Fea_Gabor_brodatz_new(img,GW,stage,orientation,varargin)

%A = fft2(img);
A=img;
F = [];
z = zeros(1,2);

if length(varargin) > 0;
    mask = varargin{1};
    workspace = ones(sum(sum(mask)), 1);
    
	for s = 1:stage,
        for n = 1:orientation, 
            D = abs(ifft2(A.*GW{s,n}));
            
            [w,h] = size(D);
            k = 1;
            for i=1:1:w;
                for j=1:1:h;
                  if ~mask(i,j);
                      continue;
                  end
                  
                  workspace(k) = D(i,j);
                  k = k + 1;
                end
            end
            
            z(1,1) = mean(workspace);
            z(1,2) = var(workspace, 1); 
            F((s-1)*orientation+n,1:2) = z;
        end;
	end;
else
    k=1;
	for s = 1:stage,
        for n = 1:orientation, 
            D{k}= abs(conv_fft2(A,GW{s,n},'same'));
            %figure()
            %imagesc(D{k}), colormap('gray')
            %D{k}= abs(conv2(A,GW{s,n},'same'));
            %D{k}=imfilter(A,GW{s,n},'same','conv');
            D1=D{k};
            k=k+1;
            DFlat = reshape(D1, numel(D1), 1);
            z(1,1) = mean(DFlat);
            z(1,2) = var(DFlat, 1); 
            F((s-1)*orientation+n,1:2) = z;
        end;
	end;
end
