function y = simulateGK(A,B,c,g,k,nsamples);

z = randn(nsamples,1);

egz = exp(-g*z);

y = A + B*(1+ c* (1-egz) ./ (1 + egz)).* ( 1 + z.^2).^k .* z; 