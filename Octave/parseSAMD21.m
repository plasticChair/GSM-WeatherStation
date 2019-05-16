clear
##samd21_lowspdCapture

##meanCounts = mean(temp(:,2));
##meanAneSpd = mean(temp(:,1));
capture3
##time = capture1(:,1);
aneSpd = capture1(1:end-13,2);
counts = capture1(1:end-13,3);

##idx = find(aneSpd >60);
##aneSpd( idx) = (aneSpd( idx-1) + aneSpd( idx+1))/2;
##idx = find(aneSpd < 30);
##aneSpd( idx) = (aneSpd( idx)) ;



n = 10;
for kk = 1:length(aneSpd)-n
  x = aneSpd(kk:kk+n-1) 
  filtOut(kk) = median(x);
endfor

##figure(44),clf
##hold all
##plot(1:length(in),in)






idx = find(counts ==0);
counts( idx) = 32000


countMph = samd21_windCalc(counts);

time = linspace(0,length(counts)*3,length(counts));
figure(1),clf
hold all
grid on
plot(time,aneSpd)
plot(time,countMph)
plot(time,filtLPF(countMph,0.2))
plot((1:length(filtOut))*3+n,filtOut)
legend("raw ane","count MPh","LPF","median")

temp = filtLPF(counts,0.2)';
figure(2),clf
hold all
grid on
plot(time,(1./(temp./32768) * 60)./aneSpd)
mean((1./(temp./32768) * 60)./aneSpd)


##[time,aneSpd,counts] = textread( 'capture1.txt', '%s,%f,%d' ,'delimiter' , ',' ,1 );


##meanSec = meanCounts/32768;
##SF = (1/meanSec)*60/meanAneSpd

