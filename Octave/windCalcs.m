clear
clc
% close all
timeLength = 900;
dt = 1/1000;
t = [0:dt:timeLength];
load xy3


[m,n]  = size(xy);
y = xy(:,2)*0.5;


windSpeed_interp = interp1(t(end)*[0:1:m-1]/(m-1),y,t)* 60;
windSpeed_MPH = filtLPF(windSpeed_interp, 0.1);

windSpeed_MPH =  awgn(windSpeed_MPH,5);
windSpeed_MPH = abs(windSpeed_MPH);

figure(1),clf
subplot(411)
plot(t,windSpeed_MPH)
ylabel('MPH')

wind_SF = 22;

windRPM = windSpeed_MPH* wind_SF;
subplot(412)
plot(t,windRPM)
ylabel('RPM')

windRPS = windRPM/60;
subplot(413)
hold all
plot(t,windRPS)
ylabel('rps')


pulseDur = 1./windRPS;
pulseDur_round = round((1./windRPS)*1000)/1000;

figure(2),clf,hold all
plot(t, pulseDur )
plot(t, pulseDur_round * 1000)
ylabel('time between pulses (ms)')
ylim([0 0.5])



anePos = cumtrapz(t,windRPS);
figure(4),clf
subplot(311)
plot(t,anePos)
subplot(312)
plot(t, mod(anePos,1))
subplot(313)
plot(t(1:end-1), diff(mod(anePos,1)))


sampleIdx = find(diff(mod(anePos,1)) < -0.9);
sampledPulseDur = pulseDur(sampleIdx);
sampledPulseTime = t(sampleIdx);
% create variable length sampled based array
% sampledPulseDur  = pulseDur(1);
% sampledPulseTime = t(1);
% count = 2;
% idxGrab = 1;
% for ii = 1: length(pulseDur)
%     
%     pulseDur(idxGrab);
%     if (t(ii)> (pulseDur(idxGrab)+t(idxGrab)))
%         sampledPulseDur(count)  = pulseDur(ii);
%         sampledPulseTime(count) = t(ii);
%         count = count +1;
%         idxGrab = ii;
%     end
% end


idx = 1;
bufsize = 40;
filter = zeros(1,bufsize);
alpha = 0.1;
filter(1) ;
lpf_filt(1) = sampledPulseDur(1);
for ii = 2: length(sampledPulseDur)
    
   %input
   filter(idx) = sampledPulseDur(ii);
   
   idx = idx + 1;
   if (idx > bufsize)
      idx = 1 ;
   end
   
   tempfilter = filter;
   
   for kk = 1:bufsize
       for jj = kk+1:bufsize
           if(tempfilter(jj) > tempfilter(kk))
               temp = tempfilter(kk);
               tempfilter(kk) = tempfilter(jj);
               tempfilter(jj) = temp;
           end
       end
   end   
   
   med_pulseDur(ii) = tempfilter(round(bufsize/2));
   lpf_filt(ii) =  lpf_filt(ii-1) + alpha*(sampledPulseDur(ii) - lpf_filt(ii-1));
  
end


%% Gust finder
maxData = 100;
curMax = 100;
maxTime = 0;
maxCount = 1;
timeCap = 0
for ii = 1: length(sampledPulseDur)
    
    sampledPulseDur(ii);
    maxData;
    if ((sampledPulseDur(ii)) < curMax)
        maxData(maxCount) = sampledPulseDur(ii);
        maxTime(maxCount) = sampledPulseTime(ii);        
%         timeCap =  maxTime(maxCount);
        curMax =  maxData(maxCount);
    end
    
    if ((sampledPulseTime(ii) - timeCap) > 300)
        curMax = 100;
        timeCap = sampledPulseTime(ii);
%         maxData(maxCount)
        maxCount = maxCount +1;
    end
    
end

sampledTime = 0;
count = 1;
for ii = 1: length(sampledPulseDur)

    if((sampledPulseTime(ii)- sampledTime) > 60)
        sampledTime = sampledPulseTime(ii);
        storedData(count) = sampledPulseDur(ii);
        storedTime(count) = sampledPulseTime(ii);
        count = count + 1;
    end
    
end



figure(2)
plot(sampledPulseTime,med_pulseDur*1000)
plot(sampledPulseTime,lpf_filt*1000)

figure(1), subplot(413)
plot(sampledPulseTime,1./med_pulseDur,'x')
plot(sampledPulseTime,1./lpf_filt,'o')


figure(1), subplot(414)
plot(sampledPulseTime,1./sampledPulseDur,'x')
ylabel('Attiny sampled data')



% figure(3)
% plot(sampledPulseTime(1:end-1), diff(sampledPulseDur))

figure(5),clf
##subplot(211)
hold all
plot(t,windSpeed_MPH)
plot(sampledPulseTime,(1./med_pulseDur)*60/22,'linewidth',2)
plot(sampledPulseTime,(1./lpf_filt)*60/22,'linewidth',2)

plot(maxTime,1./maxData *60/22,'rx','linewidth',4)
plot(t,filtLPF(windSpeed_MPH,0.12))

ylabel('Wind Speed (mph)')
xlabel('Time(sec')
legend('Real wind',['Median Filter - size ' num2str(bufsize)],['LPF - a=' num2str(alpha)], ' Peak Detect', 'ANE Sim' )
grid on

##
##
##subplot(212)
##hold all
##plot(sampledPulseTime,1./sampledPulseDur,'x')
##ylabel('Attiny sampled data')
##xlabel('Time(sec')
##grid on
##plot(storedTime,1./storedData,'rx','linewidth',2)
##
##storedWind = 1./storedData * 60/20;
##mean(storedWind)
##std(storedWind)


