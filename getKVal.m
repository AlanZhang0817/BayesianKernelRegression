function value = getKVal(x1, x2, r)
% use RBF
value = exp((- 1 / (2 * r ^ 2)) * abs(x1 - x2));
end