% initialization 
kernelsize = 9;
kRadius    = (sqrt(kernelsize) - 1) / 2;
r          = 1.2;   % declare the brandwidth of the Gaussian kernel
eta        = 0.001; % declare the step size eta

img = double(imread('lena.jpg'));  % read in image
sigma      = 30;   % standard deviation of noise added on the image
randn('state', 0);
y = round0_255(img + randn(size(img)) * sigma); % generate noisy image

% y = y(100 : 300, 200 : 400);
% imshow(uint8(y));

%%
padImg = padding(kernelsize, y); % pad image based on the size of kernel

resMatrix = cell(1, (size(padImg, 1) - 2 * kRadius) * (size(padImg, 2) - 2 * kRadius)); % initialize result matrix
index = 1;
for row = 1 + kRadius : size(padImg, 1) - kRadius
    for col = 1 + kRadius : size(padImg, 2) - kRadius
        sample = padImg(row - kRadius : row + kRadius, col - kRadius : col + kRadius);
%         [W_MAP, variance0_MAP, Variance_MAP, variance_unknown] = getAll(sample, r, eta, kernelsize);
%         resMatrix(index) = {{W_MAP, variance0_MAP, Variance_MAP, variance_unknown}};
        [W_MAP, ~, ~, ~] = getAll(sample, r, eta, kernelsize);
        resMatrix(index) = {W_MAP};
        index = index + 1;
    end
end

resMatrix = reshape(resMatrix, [size(padImg, 1) - 2 * kRadius, size(padImg, 2) - 2 * kRadius]);

% finalWeights = cell(1, (size(y, 1) * size(y, 2)));
% ii = 1;
% for row = 1 + kRadius : size(resMatrix, 1) -kRadius
%     for col = 1 + kRadius : size(resMatrix, 2) -kRadius
%         weights = zeros(kernelsize + 1, 1);
%         for offsetI = row - kRadius : row + kRadius
%             for offsetJ = col - kRadius : col + kRadius
%                 weights = weights + resMatrix{offsetI, offsetJ};
%             end
%         end
%         finalWeights(ii) = {weights / kernelsize};
%         ii = ii + 1;
%     end
% end

finalWeightsII = 1;
predictions = zeros(1, size(y, 1) * size(y, 2));
for indexii = 1 + 2 * kRadius : size(padImg, 1) - 2 * kRadius
    for indexjj = 1 + 2 * kRadius : size(padImg, 2) - 2 * kRadius
        frame = padImg(indexii - kRadius : indexii + kRadius, indexjj - kRadius : indexjj + kRadius);
        input = reshape(frame, [kernelsize, 1]);
        Y = getYVec(finalWeights{finalWeightsII}, input, r);
        predictions(finalWeightsII) = Y(ceil(size(Y, 1) / 2));
        finalWeightsII = finalWeightsII + 1;
    end
end

predictions = reshape(predictions, size(y));
%%
imshow([uint8(y) uint8(predictions)], []);