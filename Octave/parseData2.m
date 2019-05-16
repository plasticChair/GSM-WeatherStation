clear
clc


dataRaw = '00ae237acb73de8f8e524321';
dataRaw = '1234596b60546002514f117d5100';


##dataRaw = '0015d711f41520064506b6954321';
dataRaw   = '161164401922551578616215254255'
%dataRaw = '214352323332323232323232';

byteSize = [4,4,5,5,6,6,4,10,11,10,10,10,8,8,8];


for ii = 1:floor(length(dataRaw)/8)
    dataBuff(ii,:) = (dataRaw(end - ((ii-1)*8+8-1):end - (ii-1)*8)); %4 bytes, uint32
end
dataBuff(4,:) = '00000015';
dataBuff = dataRaw(end-8:end)
dataBuff


dec2bin(hex2dec(dataBuff))
temp2byte = 0;
segCount =  1; % 0
shiftRem =  0;
dataRem = 0;
sumBytes = 0;
diff = 0;
idxCount = 1;
workingByte = hex2dec(dataBuff(idxCount,:));
bitShiftCheck = 0
remBits = 32;

shiftCount = 8;
for ii= 1: length(byteSize)
    byteSize(ii)
    sumBytes = sumBytes + byteSize(ii)
    
    
##    if sumBytes > 32
##        disp('here')
##        diff = remBits
##        sumBytes = diff
##        idxCount = idxCount +1;
##        incoming = dec2bin(hex2dec(dataBuff(idxCount,:)))
##        workingByte = bitor(bitand(bitshift(hex2dec(dataBuff(idxCount,:)) , diff),2^32-1),workingByte);
##        dec2bin(workingByte)
##        bitShiftCheck = 1;
##        remBits = 32+ diff;
##    end
##    
##    if (sumBytes > diff) && bitShiftCheck 
##        disp('here2')
##        temp = bitand(bitshift(hex2dec(dataBuff(idxCount,:)), -32+diff), 2^(diff)-1);
##        dec2bin(temp)
##        workingByte = bitor(workingByte,bitshift(temp, diff));
##        dec2bin(workingByte)
##        bitShiftCheck = 0;
##        
####        sumBytes = sumBytes + diff;
##    end
    
      byteSize(ii)
      fprintf('Wokring byte b4 = %s\r\n',dec2bin(workingByte))
      dataOut  = bitand(workingByte, 2^byteSize(ii) -1)
      fprintf('dataOut (bin)= %s\r\n',dec2bin(dataOut))
      
      workingByte = bitshift(workingByte,-byteSize(ii));
       fprintf('Wokring byte  = %s\r\n',dec2bin(workingByte))
       length(dec2bin(workingByte))
       remBits = remBits - byteSize(ii)
       
       for ii = 1:byteSize(ii)/2
        workingByte = bitor(workingByte,bitshift(hex2dec(dataRaw(end-shiftCount)),ii))
        shiftCount = shiftCount +1;
       end
      

%     segSize      = ceil(byteSize(ii)/4 + shiftRem);
%     fullByteUsed = floor(byteSize(ii)/4 + shiftRem);
%     segRem       = rem(byteSize(ii) - shiftRem,4);
%     segment      = dataRaw(end - segCount + segSize -1: end - segCount)
%     segCount     = segCount + segSize;
    
%     fprintf('SegSize = %d \r\n SegRem = %d \r\n SegCount = %d \r\n',segSize,segRem, segCount)r
    
%     if (segRem >= 1)
%         shiftAmount = segSize*4 - byteSize(ii)   
%         
%     else 
%         shiftAmount = 0
%     end
%     
%     dataUse = bitor(bitshift(hex2dec(segment), shiftRem), dataRem)
%     
%     dataOut  = bitand(dataUse, 2^byteSize(ii) -1)
%     
    
% %     dataRem  = bitshift(hex2dec(segment), -byteSize(ii))
%     shiftRem = shiftAmount;
    
    display('-------------------')
%     dataOut = bitand(data4Byte, 2^byteSize(ii) -1)
%     
%     data4Byte = bitshift(data4Byte,byteSize(ii))
%     
%     bytesUsed = (byteSize(ii)/2)
%     
%     getNib(dataRaw,ii) 
    
end

function dataOut = getData(dataRaw, size)

%     size/4

end

function dataOut = getNib(dataRaw,count)

    dataOut =  dataRaw(count);

end


##1, 1
##2, 10
##3, 11
##10, 1010
##37, 100101
##54, 110110
##10, 1010
##321, 101000001
##100, 1100100
##576, 1001000000
##522, 1000001010
##574, 1000111110
##184, 10111000
##174, 10101110
##--------------------
##21, 100001
##43, 1000011
##95, 10010101
##B6, 10110110
##6, 110
##45, 1000101
##6, 110
##20, 100000
##15, 10101
##F4, 11110100
##11, 10001
##D7, 11010111
##15, 10101
##0, 0
