clear
clc

##table2data
##table4data

table5data
##table(:,2) = (table(:,2)/1e6)*60.0*22;

sigFig = 100;
aneData = table(:,1)';
pulseRaw = bitshift(round(table(100,2)) , 8);
pulseRaw = bitshift(pulseRaw,-8)
pulseData = (1./(1e-6*pulseRaw')) * 60; 

pulseData2 = (1./(1e-6*table(:,2)')) * 60; 

##[datap,idxp] = find(pulseData > 800);

##pulseData(idxp) = [];
##aneData(idxp) = [];

time = [1:2:length(aneData)*2];

figure(1),clf
subplot(211)
hold all
plot(time,aneData)
xlabel('Time (sec)')
ylabel('MPH')
grid on

subplot(212)
plot(time,pulseData)
xlabel('Time (sec)')
ylabel('RPM')
grid on

figure(2),clf
subplot(211)
plot(time,pulseData./aneData)
xlabel('Time (sec)')
ylabel('SF')
grid on

##alpha = 0.12;
##filterSF = pulseData(1);
##for ii = 2:length(time)
##  filterSF(ii) = filterSF(ii-1) +  alpha*(pulseData(ii) - filterSF(ii-1));
##end
##
##subplot(212)
##plot(time,filterSF./aneData)
##ylim([0 30])
##xlabel('Time (sec)')
##ylabel('SF')
##grid on
##
##mean(pulseData./aneData)
##mean(filterSF./aneData)


pulseMPH = 1/22;


figure(1)
subplot(211)
hold all
plot(time,pulseMPH)
plot(time, pulseData2/22)

##plot(time,filterSF/22)

min(table(:,2))






