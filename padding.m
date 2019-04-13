function retImg = padding(ksize, img)

radius = sqrt(ksize) - 1;

retImg = padarray(img,[radius radius], 0, 'both');

end