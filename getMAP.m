% X =[x1, x2, x3 ..., x_N]', r: bandwidth, W = [w0, w1, w2, ..., w_N]'
function [W_MAP, variance0_MAP, Variance_MAP, variance_unknown] = getMAP(X, W, ...
    variance_unknown, Variance_prior, variance0_prior, r, eta)

numSamples = size(X, 1);
m = sum(X) / numSamples;
tt = 1;
while tt < 10000
   tt = tt + 1;
   
   Y = getYVec(W, X, r);
   W_exclude = W(2 : end , :);
   
   % (8)
   del_L_W_exclude = zeros(size(W_exclude));
   for k = 1 : numSamples
       nominator = 0;       
       for i = 1 : numSamples
           nominator = nominator + ...
               (Y(i, :) - X(i, :)) * getKVal(X(i, :), X(k, :), r);
       end
      del_L_W_exclude(k, :) = (-1 / variance_unknown) * nominator - ...
          W_exclude(k, :) * Variance_prior(k, :);
   end

   % (9)
    del_L_W_0 = (-1 / variance_unknown) * sum(Y - X) - (W(1, :) - m) * variance0_prior;
   
   
%    if norm(del_L_W_exclude) < 10 ^ (-3)
%        break
%    end

   % (10)
   Variance_prior = 1 ./ W_exclude .^ 2;
   
   % (11)
   variance0_prior = 1 / (W(1, :) - m) ^ 2;
   

   W(2 : end , :) = W(2 : end , :) + eta * del_L_W_exclude;
   W(1, :) = W(1, :) + eta * del_L_W_0;
   
   
%    Variance_prior = Variance_prior - eta * del_Variance_prior;
%    variance0_prior = variance0_prior - eta * del_variance0_prior;
   
   % (12)
   variance_unknown = sum((Y - X) .^ 2) / (numSamples - 1);
    
   breakF = false;
   for i = 1 : numSamples + 1
       if abs(W(i, :)) < 0.01
           breakF = true;
       end
   end
   
   if breakF
       break;
   end
   
end
tt;
W_MAP = W;
Variance_MAP = Variance_prior;
variance0_MAP = variance0_prior;

end