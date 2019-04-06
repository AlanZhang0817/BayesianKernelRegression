% X =[x1, x2, x3 ..., x_N]', r: bandwidth, W = [w0, w1, w2, ..., w_N]'
function Y = getYVec(W, X, r) 

numSamples = size(X, 1);

TransPhi = zeros(numSamples);

for row = 1 : numSamples  
    for col = 1 : numSamples
        TransPhi(row, col) = getKVal(X(row, :), X(col, :), r);
    end
end

TransPhiAug = [ones(numSamples, 1) TransPhi];

Y = TransPhiAug * W;
end