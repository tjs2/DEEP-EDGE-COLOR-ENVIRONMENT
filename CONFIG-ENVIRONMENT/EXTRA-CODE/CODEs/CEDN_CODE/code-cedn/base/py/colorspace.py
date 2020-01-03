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
               7 : convert_BGR_HSV}

    converted = options[color.value](bgr)
  elif (color != ColorTransFormation.BGR):
    raise Exception('Unexpected color model: ' + color.name)

  return converted

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
