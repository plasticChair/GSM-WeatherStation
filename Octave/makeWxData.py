import collections
from bitstruct import *
import ctypes
import time


valDef = [ # Name       bits  SF        Offset  Input
          ("year"     , [4,  1      ,    0,    1     ]),
          ("month"    , [4,  1      ,    0,    2     ]),
          ("day"      , [5,  1      ,    0,    3     ]),
          ("hour"     , [5,  1      ,    0,    10    ]),
          ("minute"   , [6,  1      ,    0,    37    ]),
          ("second"   , [6,  1      ,    0,    54    ]),
          ("dir"      , [12,  1      ,    0,    10    ]),
          ("speed"    , [10, 8.9737 ,    0,    35.8  ]),
          ("gustMax"  , [11, 1      ,    0,    100  ]),
          ("temp"     , [10, 10.7684,  -30,    23.5  ]),
          ("press"    , [10, 5.115  ,  900,    1002.1]),
          ("humid"    , [10, 10.23  ,    0,    56.1  ]),
          ("batteryV" , [8,  212.5  ,    3,    3.865  ]),
          ("batteryP" , [8,  2.55   ,    0,    68.4 ] ),
          ("checksum" , [8,  1      ,    0,    1    ])
]

wxDataRaw = collections.OrderedDict(valDef)

data = []
sizeStr = ""
count = 0
strData = ""
ctypesArray= []
sum = 0
for x in wxDataRaw:
    #print(x)
    #print(int(round((wxDataRaw[x][3] - wxDataRaw[x][2]) * wxDataRaw[x][1])) & ((2 ** wxDataRaw[x][0]) - 1))
    data.append(int(round((wxDataRaw[x][3] - wxDataRaw[x][2]) * wxDataRaw[x][1])) & ((2 ** wxDataRaw[x][0]) - 1))
    sizeStr = sizeStr + 'u' + str(wxDataRaw[x][0])
    sum = sum +  wxDataRaw[x][0]
    ctypesArray.append((x, ctypes.c_uint32, wxDataRaw[x][0]))

numbytes = round(sum/8)
print(numbytes)
#print(numbytes)
#print(len(valDef))
#cf = compile(sizeStr)
#cData = cf.pack(*data)
#print(ctypesArray)

class PacketBits(ctypes.LittleEndianStructure):
    _fields_ = [
        *ctypesArray
    ]

class Packet(ctypes.Union):
    _fields_ = [("vals", PacketBits),
                ("binary_data", ctypes.c_uint8*14 )]

packet = Packet()
#print(data)
#print('[{}]'.format(', '.join(hex(x) for x in data)))
# Manual method :(
packet.vals.year     = data[0]
packet.vals.month    = data[1]
packet.vals.day      = data[2]
packet.vals.hour     = data[3]
packet.vals.minute   = data[4]
packet.vals.second   = data[5]
packet.vals.dir      = data[6]
packet.vals.speed    = data[7]
packet.vals.gustMax  = data[8]
packet.vals.temp     = data[9]
packet.vals.press    = data[10]
packet.vals.humid    = data[11]
packet.vals.batteryV = data[12]
packet.vals.batteryP = data[13]
packet.vals.checksum = data[14]

print(data)
#for x in wxDataRaw:
#    print('packet.bits.' + x + ' = wxDataRaw[\'' + x + '\'][3]')
#    eval('packet.bits.' + x + ' = wxDataRaw[\'' + x + '\'][3]')



######## Encoded OUTPUT ########
print(["0x%02x" % x for x in packet.binary_data])
temp = [x for x in packet.binary_data]
#for x in range(len(temp)):
    #print(bin(temp[x]))

print('Num bytes : ' + str(numbytes))
#print([ x for x in packet.binary_data])

mylist = ["%02x" % x for x in packet.binary_data]
print("".join(reversed("".join(reversed(mylist)))))
print("".join(reversed(mylist)))
print("".join((mylist)))

#ctypes.c_char_p(
######## decode ########

testData = [33,67,149,182,6,69,32,21,244,17,215,21,0]

print(hex(testData))



#packetDecode = Packet()
#packetDecode.binary_data =testData
#
#dataWX = []
#for x in ctypesArray:
#    tempData = eval('packetDecode.vals.'+ x[0])
#    #print(tempData)
#    dataWX.append((x[0], tempData / wxDataRaw[x[0]][1] + wxDataRaw[x[0]][2] ))
# #   #dataWX.append((x[0]),)
#
#
######### DECODED OUTPUT ########
#print(dataWX)






