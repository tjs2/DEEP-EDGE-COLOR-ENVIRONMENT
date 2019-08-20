import numpy as np
import scipy.misc
from PIL import Image
import scipy.io
import os
import colorspace as c

caffe_root = '../../../'  # this file is expected to be in {caffe_root}/examples/hed/
import sys
sys.path.insert(0, caffe_root + 'python')

import caffe

# Config
caffe.set_mode_gpu()
caffe.set_device(0)

if __name__ == '__main__':
  print("\nArgs - test:" + str(sys.argv) + "\n")

  color = c.ColorTransFormation[sys.argv[1].strip()]

  dataset_root_folder = sys.argv[2].strip()
  dataset_file_list = sys.argv[3].strip()
  deploy_prototxt = sys.argv[4].strip()

  result_folder = sys.argv[5].strip()
  caffe_model = sys.argv[6].strip()

  # Create result folders
  if not os.path.exists(result_folder):
    os.makedirs(result_folder)

  if not os.path.exists(result_folder + '/average1-5'):
    os.makedirs(result_folder + '/average1-5')

  if not os.path.exists(result_folder + '/fuse'):
    os.makedirs(result_folder + '/fuse')

  with open(dataset_file_list) as f:
    test_lst = f.readlines()

  # Load image names
  names = [os.path.basename(x).strip().replace('.jpg', '') for x in test_lst]
  test_lst = [dataset_root_folder + x.strip() for x in test_lst]

  # Load net
  net = caffe.Net(deploy_prototxt, caffe_model, caffe.TEST)

  # Run net on each image
  for idx in range(0, len(test_lst)):

    print 'Current image: ' + str(idx+1) + ' with color ' + str(color.name) + ' - ' + test_lst[idx]

    # Open image
    im = Image.open(test_lst[idx])
    in_ = np.array(im, dtype=np.float32)

    # RGB -> BGR
    in_ = in_[:,:,::-1]

    # Subtract mean
    if (color == c.ColorTransFormation.RGB):
      in_ -= np.array((104.00698793, 116.66876762, 122.67891434))

    # Color transformation
    if (color != c.ColorTransFormation.RGB):
      in_ = c.convert_color_from_bgr(in_, color)

    # W x H x C -> C x W x H
    in_ = in_.transpose((2,0,1))

    # Shape for input (data blob is N x C x H x W), set data
    net.blobs['data'].reshape(1, *in_.shape)
    net.blobs['data'].data[...] = in_

    # Run net
    net.forward()

    # Get outputs
    out_side_1 = net.blobs['sigmoid-dsn1'].data[0][0,:,:]
    out_side_2 = net.blobs['sigmoid-dsn2'].data[0][0,:,:]
    out_side_3 = net.blobs['sigmoid-dsn3'].data[0][0,:,:]
    out_side_4 = net.blobs['sigmoid-dsn4'].data[0][0,:,:]
    out_side_5 = net.blobs['sigmoid-dsn5'].data[0][0,:,:]
    fuse = net.blobs['sigmoid-fuse'].data[0][0,:,:]

    # Get average and merge outputs
    average1_5 = (out_side_1 + out_side_2 + out_side_3 + out_side_4 + out_side_5) / 5.0
    merge = (fuse + average1_5) / 2.0

    # Save results
    scipy.io.savemat(result_folder + '/average1-5/' + names[idx] + '.mat', {'average1_5':average1_5})
    scipy.io.savemat(result_folder + '/fuse/' + names[idx] + '.mat', {'fuse':fuse})
