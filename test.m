
W = [0.001, 0.001, 0.001, 0.001]';
X = [255, 255, 255]';
r = 1;
Variance_prior = [1, 1, 1]';
variance0_prior = 1;
eta = 0.001;
variance_unknown = 0.1;
[W_MAP, variance0_MAP, Variance_MAP, variance_unknown] = ...
    getMAP(X, W, variance_unknown, Variance_prior, variance0_prior, r, eta);

disp("W_MAP: ");
disp( W_MAP);

disp("Sigma_MAP: ");
disp(real(sqrt(Variance_MAP)));

disp("s0_MAP: ");
disp(real(sqrt(variance0_MAP)));

disp("sigma_unknown: ");
disp(real(sqrt(variance_unknown)));

% % reinterpret the value y(x1):
% 
% y = 0;
% for i = 1 : 3
%     y = y - W_MAP(i, :) * getKVal(X(i, :), X(i, :), r);
% end
% y