clear



in = [ 7 3 1 6 3 4 8 1 4 5 1 6 8 12  8 4 2 6 5 8 15 3 6 3];
n = 10;
for kk = 1:length(in)-n
  x = in(kk:kk+n-1) 
  filtOut(kk) = median(x);
endfor

figure(44),clf
hold all
plot(1:length(in),in)
plot(1:length(filtOut),filtOut)


