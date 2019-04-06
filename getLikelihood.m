% X =[x1, x2, x3 ..., x_N]', r: bandwidth, T = [t1, t2, ..., t_N]', 
% sigma: unknown, W
function likelihood = getLikelihood(X, T, sigma, W, r)

numSamples = size(X, 1);
Y = getYVec(W, X, r);

likelihood = 1;

for i = 1 : numSamples
    likelihood = likelihood * ...
        (1 / (sqrt(2 * pi) * sigma)) * ...
        exp((- 1 / (2 * sigma ^ 2)) * (Y(i, :) - T(i, :)) ^ 2);
end

end