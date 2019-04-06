% W = [w0, w1, w2, ..., w_N]', X =[x1, x2, x3 ..., x_N]'
% hyperpram: given sigma_0, Sigma = [sig1, sig2, ..., sig_N]'
function prior = getPrior(X, W, sigma_0, Sigma)

numSample = size(X, 1);
m = sum(X) / numSample;
W_exclude = W(2 : end , :);
prior = 1;

for i = 1 : numSample
   prior = prior * ...
       (1 / (2 * pi * Sigma(i, :) * sigma_0)) * ...
       exp((- 1 / (2 * Sigma(i, :) ^ 2)) * W_exclude(i, :) ^ 2) * ...
       exp((- 1 / (2 * sigma_0 ^ 2)) * (W(1, :) - m) ^ 2);
end

end