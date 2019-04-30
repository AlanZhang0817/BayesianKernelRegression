% initialization 
kernelsize = 25;
kRadius    = (sqrt(kernelsize) - 1) / 2;
r          = 1.2;   % declare the brandwidth of the RBF kernel
eta        = 0.001; % declare the step size eta
h          = 1;   % weights 
sigma      = 100;   % standard deviation of noise added on the image
img = double(imread('lena.jpg'));  % read in image
randn('seed', 0);
y = round0_255(img + randn(size(img)) * sigma); % generate noisy image

% imshow(uint8(y), []);

% y = y(20 : 40, 20 : 40);
% img = img(20 : 40, 20 : 40);
%imshow(uint8(y));

classical_kernel_filtering = regular_kernel(kernelsize, y, h);
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
    disp("learning at row : " + row);
end

resMatrix = reshape(resMatrix, [size(padImg, 1) - 2 * kRadius, size(padImg, 2) - 2 * kRadius]);

% revise starts here
predict_y_from_all_W = zeros(1, (size(y, 1) * size(y, 2))); % the predictions of y for the same pixcel
weights = getWeights(sqrt(kernelsize), h) / sum(sum(getWeights(sqrt(kernelsize), h)));
weights = reshape(weights, [1, kernelsize]);
ii = 1;

for row = 1 + 2 * kRadius : size(padImg, 1) - 2 * kRadius
   for col = 1 + 2 * kRadius : size(padImg, 2) - 2 * kRadius
       predicts_y = zeros(kernelsize, 1);
       jj = 1;
       for offsetI = row - kRadius : row + kRadius
           for offsetJ = col - kRadius : col + kRadius 
                frame = padImg(offsetI - kRadius : offsetI + kRadius, offsetJ - kRadius : offsetJ + kRadius);
                input = reshape(frame, [kernelsize, 1]);
                Y = getYVec(resMatrix{offsetI - kRadius, offsetJ - kRadius}, input, r);
                predicts_y(jj, 1) = min(max(Y(kernelsize - jj + 1, 1), 0), 255);
                jj = jj + 1;
           end
       end
       predict_y_from_all_W(ii) = weights * predicts_y;
       ii = ii + 1;
   end
   disp("predicting at row : " + row);
end
predictions = reshape(predict_y_from_all_W, size(y));

% for row = 1 + kRadius : size(resMatrix, 1) - kRadius
%     for col = 1 + kRadius : size(resMatrix, 2) - kRadius
%         predicts_y = zeros(kernelsize, 1);
%         jj = 1;
%         for offsetI = row - kRadius : row + kRadius
%             for offsetJ = col - kRadius : col + kRadius
%                 frame = padImg(offsetI - kRadius : offsetI + kRadius, offsetJ - kRadius : offsetJ + kRadius);
%                 input = reshape(frame, [kernelsize, 1]);
%                 Y = getYVec(resMatrix{offsetI, offsetJ}, input, r);
%                 predicts_y(jj, 1) = Y(kernelsize - jj, 1);
%                 jj = jj + 1;
%             end
%         end
%         predict_y_from_all_W(ii) = weights * predicts_y;
%         ii = ii + 1;
%     end
% end

% finalWeights = cell(1, (size(y, 1) * size(y, 2)));
% weights = getWeights(sqrt(kernelsize), h) / sum(sum(getWeights(sqrt(kernelsize), h)));
% weights = reshape(weights, [1, kernelsize]);
% ii = 1;
% for row = 1 + kRadius : size(resMatrix, 1) -kRadius
%     for col = 1 + kRadius : size(resMatrix, 2) -kRadius
%         weights_sum = zeros(kernelsize + 1, 1);
%         jj = 1;
%         for offsetI = row - kRadius : row + kRadius
%             for offsetJ = col - kRadius : col + kRadius
%                 weights_sum = weights_sum + weights(jj) * resMatrix{offsetI, offsetJ};
%                 jj = jj + 1;
%             end
%         end
%         finalWeights(ii) = {weights_sum};
%         ii = ii + 1;
%     end
% end

% finalWeightsII = 1;
% predictions = zeros(1, size(y, 1) * size(y, 2));
% for indexii = 1 + 2 * kRadius : size(padImg, 1) - 2 * kRadius
%     for indexjj = 1 + 2 * kRadius : size(padImg, 2) - 2 * kRadius
%         frame = padImg(indexii - kRadius : indexii + kRadius, indexjj - kRadius : indexjj + kRadius);
%         input = reshape(frame, [kernelsize, 1]);
%         Y = getYVec(finalWeights{finalWeightsII}, input, r);
%         predictions(finalWeightsII) = Y(ceil(size(Y, 1) / 2));
%         finalWeightsII = finalWeightsII + 1;
%     end
% end
% 
% predictions = reshape(predictions, size(y));
%%
imshow([uint8(img) uint8(y)  uint8(predictions) uint8(classical_kernel_filtering)], []);

org_noise = immse(y, predictions);
prediction_org = immse(img, predictions);
classi_org = immse(img, classical_kernel_filtering);
disp("The original vs noise mse is " + org_noise);
disp("The original vs prediction mse is " + prediction_org);
disp("The original vs Gaussian Filtering is " + classi_org);
