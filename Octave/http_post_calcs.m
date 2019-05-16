clear
clc

windDir = '123';
windSpd = '12';
gusts = '12';
temp = '67';
hum = '43';
pressure = '123.2';
batt = '232';

str = [windDir,',',windSpd,',', gusts,',', temp,',', hum,',', pressure,',', batt] 
strLen = length(str)

byteSize = strLen*1 + 5
postSize = ceil(byteSize*1.25)

OnTimeMin = 16*60;  %5am to 9pm)
updatePday = (OnTimeMin)/15  
sampleRate = OnTimeMin/1

numMessagesPupdate = sampleRate/updatePday
sizePupdate_bytes = postSize*numMessagesPupdate
sizePday_kbytes = sizePupdate_bytes*updatePday/1024

sizePmonth_kbytes = sizePday_kbytes*31
sizePyear_mbytes = sizePmonth_kbytes*12/1024






