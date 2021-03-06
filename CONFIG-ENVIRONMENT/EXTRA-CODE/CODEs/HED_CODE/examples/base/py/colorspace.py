from enum import Enum
import numpy as np
import cv2

class ColorTransFormation(Enum):
  BGR = -1
  RGB = 0
  LAB = 1
  LUV = 2
  YO1O2 = 3
  I1I2I3 = 4
  dRdGdB = 5
  RGBdRdGdB = 6
  HSV = 7
  YUV = 8
  YIQ = 9
  YPbPr = 10
  YDbDr = 11
  YCbCr = 12

def convert_color_from_rgb(rgb, color):
  converted = rgb

  if (color in list(ColorTransFormation) and color != ColorTransFormation.RGB):
    converted = convert_color_from_bgr(rgb[:,:,::-1], color)

  return converted

def convert_color_from_bgr(bgr, color):
  converted = bgr

  if (color == ColorTransFormation.RGB):
    converted = bgr[:,:,::-1]
  elif (color in list(ColorTransFormation) and color != ColorTransFormation.BGR):
    options = {1 : convert_BGR_LAB,
               2 : convert_BGR_LUV,
               3 : convert_BGR_YO1O2,
               4 : convert_BGR_I1I2I3,
               5 : convert_BGR_dRdGdB,
               6 : convert_BGR_RGBdRdGdB,
               7 : convert_BGR_HSV,
               8 : convert_BGR_YUV,
               9 : convert_BGR_YIQ,
               10 : convert_BGR_YPbPr,
               11 : convert_BGR_YDbDr,
               12 : convert_BGR_YCbCr}

    converted = options[color.value](bgr)
  elif (color != ColorTransFormation.BGR):
    raise Exception('Unexpected color model: ' + color.name)

  return converted

def convert_BGR_YUV(bgr):
  
  transfomMatrix = [[ 0.299,  0.587,  0.114],
                    [-0.147, -0.289,  0.436],
                    [ 0.615, -0.515, -0.100]]
  alpha = [1.0, 1.0, 1.0]
  delta = [0.0, 0.0, 0.0]

  ret = bgrTransformation(bgr, transfomMatrix, alpha, delta)

  return ret

def convert_BGR_YIQ(bgr):
  
  transfomMatrix = [[0.299,     0.587,     0.114   ],
                    [0.595716, -0.274453, -0.321263],
                    [0.211456, -0.522591,  0.311135]]
  alpha = [1.0, 1.0, 1.0]
  delta = [0.0, 0.0, 0.0]

  ret = bgrTransformation(bgr, transfomMatrix, alpha, delta)

  return ret

def convert_BGR_YPbPr(bgr):
  
  transfomMatrix = [[ 0.299,      0.587,     0.114   ],
                    [-0.1687367, -0.331264,  0.5     ],
                    [ 0.5,       -0.418688, -0.081312]]
  alpha = [1.0, 1.0, 1.0]
  delta = [0.0, 0.0, 0.0]

  ret = bgrTransformation(bgr, transfomMatrix, alpha, delta)

  return ret

def convert_BGR_YDbDr(bgr):
  
  transfomMatrix = [[ 0.299,  0.587, 0.114],
                    [-0.450, -0.883, 1.333],
                    [-1.333,  1.116, 0.217]]
  alpha = [1.0, 1.0, 1.0]
  delta = [0.0, 0.0, 0.0]

  ret = bgrTransformation(bgr, transfomMatrix, alpha, delta)

  return ret

def convert_BGR_YCbCr(bgr):
  
  transfomMatrix = [[ 65.481, 128.553,  24.966],
                    [-37.797, -74.203, 112.0  ],
                    [112.0,   -93.786, -18.214]]
  alpha = [ 1.0,   1.0,   1.0]
  delta = [16.0, 128.0, 128.0]

  ret = bgrTransformation(bgr, transfomMatrix, alpha, delta)

  return ret

def bgrTransformation(bgr, transfomMatrix, alpha, delta):
  bgr32F = np.float32(bgr)
  bgrSplitted = cv2.split(bgr32F)

  R = 2
  G = 1
  B = 0

  channel1 = alpha[0] * ( bgrSplitted[R] * transfomMatrix[0][0] + bgrSplitted[G] * transfomMatrix[0][1] + bgrSplitted[B] * transfomMatrix[0][2] ) + delta[0]
  channel2 = alpha[1] * (-bgrSplitted[R] * transfomMatrix[1][0] - bgrSplitted[G] * transfomMatrix[1][1] + bgrSplitted[B] * transfomMatrix[1][2] ) + delta[1]
  channel3 = alpha[2] * ( bgrSplitted[R] * transfomMatrix[2][0] - bgrSplitted[G] * transfomMatrix[2][1] - bgrSplitted[B] * transfomMatrix[2][2] ) + delta[2]

  transfomed = cv2.merge((channel1, channel2, channel3))
  return transfomed

def convert_BGR_LAB(bgr):
  bgr32F = np.float32(bgr) / 255.0
  Lab = cv2.cvtColor(bgr32F, cv2.COLOR_BGR2LAB)
  return Lab

def convert_BGR_LUV(bgr):
  bgr32F = np.float32(bgr) / 255.0
  Lab = cv2.cvtColor(bgr32F, cv2.COLOR_BGR2LUV)
  return Lab

def convert_BGR_HSV(bgr):
  bgr32F = np.float32(bgr) / 255.0
  hsv_ = cv2.cvtColor(bgr32F, cv2.COLOR_BGR2HSV)

  H = 0
  S = 1
  V = 2

  hsvSplitted = cv2.split(hsv_)
  hsvSplitted[H] = hsvSplitted[H] / 180.0;
  hsvSplitted[H] = hsvSplitted[H] * cv2.cv.CV_PI; # 0 <= H <= 2pi
  hsv = cv2.merge((hsvSplitted[H], hsvSplitted[S], hsvSplitted[V]))

  return hsv

def convert_BGR_dRdGdB(bgr):
  bgr32F = np.float32(bgr)
  bgrSplitted = cv2.split(bgr32F)

  R = 2
  G = 1
  B = 0

  # (R - G) + (R - B)
  dR = (bgrSplitted[R] - bgrSplitted[G]) + (bgrSplitted[R] - bgrSplitted[B]);
  # (G - R) + (G - B)
  dG = (bgrSplitted[G] - bgrSplitted[R]) + (bgrSplitted[G] - bgrSplitted[B]);
  # (B - R) + (B - G)
  dB = (bgrSplitted[B] - bgrSplitted[R]) + (bgrSplitted[B] - bgrSplitted[G]);

  dRdGdB = cv2.merge((dR,dG,dB))
  return dRdGdB

def convert_BGR_RGBdRdGdB(bgr):
  bgr32F = np.float32(bgr)
  dRdGdB = convert_BGR_dRdGdB(bgr)

  bgrSplitted = cv2.split(bgr32F)
  dRdGdBSplitted = cv2.split(dRdGdB)

  RGBdRdGdB = cv2.merge((bgrSplitted[2], bgrSplitted[1], bgrSplitted[0], dRdGdBSplitted[0], dRdGdBSplitted[1], dRdGdBSplitted[2]))
  return RGBdRdGdB

def convert_BGR_I1I2I3(bgr):
  bgr32F = np.float32(bgr)
  bgrSplitted = cv2.split(bgr32F)

  I1 = (bgrSplitted[2] + bgrSplitted[1] + bgrSplitted[0]) / 3.0;
  I2 = (bgrSplitted[2] - bgrSplitted[0]) / 2.0;
  I3 = (2*bgrSplitted[1] - bgrSplitted[2] - bgrSplitted[0]) / 4.0;

  I1I2I3 = cv2.merge((I1,I2,I3))
  return I1I2I3

def convert_BGR_YO1O2(bgr):
  bgr32F = np.float32(bgr)
  bgrSplitted = cv2.split(bgr32F)

  R = 2
  G = 1
  B = 0

  Y = (0.2857 * bgrSplitted[R]) + (0.5714 * bgrSplitted[G]) + (0.1429 * bgrSplitted[B]);
  O1 = bgrSplitted[R] - bgrSplitted[G];
  O2 = (2.0 * bgrSplitted[B]) - bgrSplitted[R] - bgrSplitted[G];

  YO1O2 = cv2.merge((Y,O1,O2))
  return YO1O2
