#!/usr/bin/env python

# --------------------------------------------------------
# Convolutional Encoder-Decoder Networks for Contour Detection 
# Copyright (c) 2015 Microsoft
# Licensed under The MIT License [see LICENSE for details]
# Written by Ross Girshick
# --------------------------------------------------------

"""
See README.md for installation instructions before running.
"""

import time as t
import _init_paths
from utils.timer import Timer
import numpy as np
import scipy.io as sio
import caffe, os, sys, cv2
import argparse
from utils.blob import im_list_to_blob
import color_convert as cc

# PIXEL_MEANS = np.array([[[102.9801, 115.9465, 122.7717]]])
PIXEL_MEANS = np.array([[[103.939, 116.779, 123.68]]])

TEST_MAX_SIZE = 512

def _sigmoid(x):
    return 1 / (1 + np.exp(-x))

def _get_image_blob(im):
    """Converts an image into a network input.

    Arguments:
        im (ndarray): a color image in BGR order

    Returns:
        blob (ndarray): a data blob holding an image
    """
    im_orig = im;
    im_shape = im_orig.shape
    im_size_min = np.min(im_shape[0:2])
    im_size_max = np.max(im_shape[0:2])

    processed_ims = []
    # Prevent the biggest axis from being more than MAX_SIZE
    if im_size_max > TEST_MAX_SIZE:
        im_scale = float(TEST_MAX_SIZE) / float(im_size_max)
        im = cv2.resize(im, None, None, fx=im_scale, fy=im_scale,
                        interpolation=cv2.INTER_LINEAR)

    # Pad the image to the standard size (optional)
    top = (TEST_MAX_SIZE - im_shape[0]) / 2 
    bottom = TEST_MAX_SIZE - im_shape[0] - top
    left = (TEST_MAX_SIZE - im_shape[1]) / 2 
    right = TEST_MAX_SIZE - im_shape[1] - left
    im_pad = (top, bottom, left, right)
    im = cv2.copyMakeBorder(im, top, bottom, left, right, cv2.BORDER_CONSTANT, 0)
    # substract the color mean
    im = im.astype(np.float32, copy=True)
    im -= PIXEL_MEANS

    processed_ims.append(im)

    # Create a blob to hold the input images
    blob = im_list_to_blob(processed_ims)

    return blob, im_shape, im_pad

def _get_contour_map(probmap, im_shape, im_pad):
    """Convert network output to contour maps."""
     
    probmap = np.squeeze(probmap) 

    top = im_pad[0]
    bottom = im_pad[1]
    left = im_pad[2]
    right = im_pad[3]
    probmap = probmap[top:-bottom, left:-right]

    height = im_shape[0]
    width = im_shape[1]
    probmap = cv2.resize(probmap, (im_shape[1], im_shape[0])) 

    return probmap

def contour_detection(net, im):
    """Detect object contours."""

    # Detect object contours
    timer = Timer()
    timer.tic()

    # Convert image to network blobs
    blobs = {'data': None}
    blobs['data'], im_shape, im_pad = _get_image_blob(im) 
    # Reshape network inputs
#    net.blobs['data'].reshape(*(blobs['data'].shape))
    # Run forward inference
    blobs_out = net.forward(data=blobs['data'].astype(np.float32, copy=False))
    probmap = blobs_out['probmap']    
    # Convert network output to image
    probmap = _get_contour_map(probmap, im_shape, im_pad) 

    timer.toc()
    #print ('Detection took {:.3f}s').format(timer.total_time)
    
    return probmap    

def parse_args():

    """Parse input arguments."""
    parser = argparse.ArgumentParser(description='Run a Convolutional Encoder-Decoder network')
    parser.add_argument('--gpu', dest='gpu_id', help='GPU device id to use [0]', default=0, type=int)
    parser.add_argument('--cpu', dest='cpu_mode', help='Use CPU mode (overrides --gpu)', action='store_true')

    parser.add_argument('--prototxt', dest='prototxt', help='Prototxt file path')
    parser.add_argument('--caffemodel', dest='caffemodel', help='Caffe model file path')
    parser.add_argument('--imnames', dest='imnames', help='Image names file path')
    parser.add_argument('--intput', dest='intput', help='Input images path')
    parser.add_argument('--output', dest='output', help='Output boundary maps path')

    parser.add_argument('--color', dest='color', help='Input image color', default='RGB')

    args = parser.parse_args()

    return args


if __name__ == '__main__':
    args = parse_args()

    prototxt = args.prototxt
    caffemodel = args.caffemodel
    intput = args.intput
    output = args.output
    imnamesf = args.imnames
    color = args.color

    if not os.path.isfile(prototxt):
        raise IOError('Prototxt file not found: {:s}.\n'.format(prototxt))

    if not os.path.isfile(caffemodel):
        raise IOError('Caffe model file not found: {:s}.\n'.format(caffemodel))

    if not os.path.isdir(intput):
        raise IOError('Input images path not exists: {:s}.\n'.format(intput))

    if not os.path.isdir(output):
        raise IOError('Output boundary maps path not exists: {:s}.\n'.format(output))

    if not os.path.isfile(imnamesf):
        raise IOError('Image names file not found: {:s}.\n'.format(imnamesf))

    net = caffe.Net(prototxt, caffemodel)
    net.set_phase_test()

    print 'Net is initialized.\n'

    if args.cpu_mode:
        net.set_mode_cpu()
    else:
        net.set_mode_gpu()
        net.set_device(args.gpu_id)

    print '\n\nLoaded network {:s}'.format(caffemodel)
    print 'Color: {}'.format(color)

    f = open(imnamesf, 'r')
    imnames = f.readlines()

    if (color != "RGB"):
        PIXEL_MEANS = np.array([[[0.0, 0.0, 0.0]]])

    print 'Mean: '
    print PIXEL_MEANS

	totalTime = 0
	convertTime = 0
	executionTIme = 0
	
    for name in imnames:

        name = name[:-1]

        # Load the test image
        im_file = os.path.join(intput, name + '.jpg')
        im = cv2.imread(im_file)

		t1 = t.time()
		
        im = cc.color_convert(im, color)

		t2 = t.time()
		
        # Run CEDN inference
    	probmap = contour_detection(net, im)

		t3 = t.time()
		
		totalTime = totalTime + t3-t1
		convertTime = convertTime + t2-t1
		executionTIme = executionTIme + t3-t2
		
        # Save detections
        #res_file = os.path.join(output, name + '.png')
        #cv2.imwrite(res_file, (255*probmap).astype(np.uint8, copy=True))
	
	divided = len(imnames)
	print("Color: " + str(COLOR))
	print("")
	print("Quantidade imagens: " + str(divided))
	print("")
	print("\tTempo total: " + str(totalTime) + " segundos")
	print("\tTempo total convert: " + str(convertTime) + " segundos")
	print("\tTempo total execution: " + str(executionTIme) + " segundos")
	print("")
	print("\tTempo medio total: " + str(totalTime/divided) + " segundos")
	print("\tTempo medio total convert: " + str(convertTime/divided) + " segundos")
	print("\tTempo medio total execution: " + str(executionTIme/divided) + " segundos")
	print("")
