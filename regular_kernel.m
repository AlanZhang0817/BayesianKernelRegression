function retImg = regular_kernel(ksize, img, h)

% padding

radius = (ksize - 1) / 2;

%padding
D = padarray(img,[radius radius],0,'both');

weights = getWeights(ksize, h);

retImg = zeros(size(img));

for ii = 1 + radius : size(D, 1) - radius
    for jj = 1 + radius : size(D, 2) - radius
        frame = D(ii - radius : ii + radius, jj - radius : jj + radius);
        retImg(ii - radius, jj - radius) = sum(sum(weights .* frame)) / sum(sum(weights));
    end
end



end