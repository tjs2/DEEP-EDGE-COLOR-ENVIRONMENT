import color_convert as cc
import cv2

bgr = cv2.imread('im.png')

## RGB
bgr = cc.color_convert(bgr, 'RGB')

print '\r\n RGB-R'
print bgr[:, :, 2]

print '\r\n RGB-G'
print bgr[:, :, 1]

print '\r\n RGB-B'
print bgr[:, :, 0]

## LAB
lab = cc.color_convert(bgr, 'LAB')

print '\r\n LAB-L'
print lab[:, :, 0]

print '\r\n LAB-A'
print lab[:, :, 1]

print '\r\n LAB-B'
print lab[:, :, 2]

## LUV
luv = cc.color_convert(bgr, 'LUV')

print '\r\n LUV-L'
print luv[:, :, 0]

print '\r\n LUV-U'
print luv[:, :, 1]

print '\r\n LUV-V'
print luv[:, :, 2]

## YO1O2
yo1o2 = cc.color_convert(bgr, 'YO1O2')

print '\r\n YO1O2-Y'
print yo1o2[:, :, 0]

print '\r\n YO1O2-O1'
print yo1o2[:, :, 1]

print '\r\n YO1O2-O2'
print yo1o2[:, :, 2]

## I1I2I3
i1i2i3 = cc.color_convert(bgr, 'I1I2I3')

print '\r\n I1I2I3-I1'
print i1i2i3[:, :, 0]

print '\r\n I1I2I3-I2'
print i1i2i3[:, :, 1]

print '\r\n I1I2I3-I3'
print i1i2i3[:, :, 2]

## dRdGdB
drdgdb = cc.color_convert(bgr, 'dRdGdB')

print '\r\n dRdGdB-dR'
print drdgdb[:, :, 0]

print '\r\n dRdGdB-dG'
print drdgdb[:, :, 1]

print '\r\n dRdGdB-dB'
print drdgdb[:, :, 2]

## RGBdRdGdB
rgbdrdgdb = cc.color_convert(bgr, 'RGBdRdGdB')

print '\r\n RGBdRdGdB-R'
print rgbdrdgdb[:, :, 0]

print '\r\n RGBdRdGdB-G'
print rgbdrdgdb[:, :, 1]

print '\r\n RGBdRdGdB-B'
print rgbdrdgdb[:, :, 2]

print '\r\n RGBdRdGdB-dR'
print rgbdrdgdb[:, :, 3]

print '\r\n RGBdRdGdB-dG'
print rgbdrdgdb[:, :, 4]

print '\r\n RGBdRdGdB-dB'
print rgbdrdgdb[:, :, 5]

## hsv
hsv = cc.color_convert(bgr, 'HSV')

print '\r\n HSV-H'
print hsv[:, :, 0]

print '\r\n HSV-S'
print hsv[:, :, 1]

print '\r\n HSV-V'
print hsv[:, :, 2]
