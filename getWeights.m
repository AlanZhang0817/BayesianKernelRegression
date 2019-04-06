function allWeights = getWeights(ksize, h)

radius = (ksize - 1) / 2;
[x_axis, y_axis] = meshgrid(-radius : 1 : radius, -radius : 1 : radius);

allWeights = zeros(ksize);

for ii = 1 : ksize
    for jj = 1 : ksize
        allWeights(ii, jj) = exp( (-.05 / h ^ 2) * (x_axis(ii, jj) ^ 2 + y_axis(ii, jj) ^ 2));
    end 
end

end
