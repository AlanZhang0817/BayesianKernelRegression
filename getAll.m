function [W_MAP, variance0_MAP, Variance_MAP, variance_unknown] = getAll(sample, r, eta, kernelsize)

% vectorize this sample:
input = reshape(sample, [kernelsize, 1]);

% declare the initial value of Weights vector. w0, w1, ... w9
w = 0.01;
W = repelem(w,kernelsize + 1)';
W(1) = mean(input) + normrnd(0,1);
W(2 : kernelsize + 1) = normrnd(0,1,[kernelsize,1]);


% declare the initial values of sigma, which are the variance values from
% sig1^2 to sig9^2
sig = 1;
Variance_prior = repelem(sig, kernelsize)';

% declare the initial value of sigma0^2, which is 
variance0_prior = 1;

% initialize the unknown variable sigma, which is the unknown noise added
% to this image 
variance_unknown = 0.5;

%-------------------------
% start run the regression:
[W_MAP, variance0_MAP, Variance_MAP, variance_unknown] = ...
    getMAP(input, W, variance_unknown, Variance_prior, variance0_prior, r, eta);

% disp("W_MAP: ");
% disp( W_MAP);
% 
% disp("Sigma_MAP: ");
% disp(real(sqrt(Variance_MAP)));
% 
% disp("s0_MAP: ");
% disp(real(sqrt(variance0_MAP)));
% 
% disp("sigma_unknown: ");
% disp(real(sqrt(variance_unknown)));

%--------------------------
% reconstruct (predict) the image intensity

% transfer the input by the kernel function
% phiVec = zeros(1, 9);
% 
% for index = 1 : 9
%     phiVec(1, index) = getKVal(input(5), input(index), r);
% end
% 
% % compute the mean weights:
% meanW = sum(W_MAP) / size(W_MAP, 1);
% 
% % predict
% y = sum(meanW .* phiVec)
% 
% y = getYVec(W_MAP, input, r) 

end
