function train(solver_prototxt, train_prototxt, weight, outDir, imNamesfile, imDir, gtDir, color)

  addpath(genpath('../caffe-cedn/matlab'));
  
  USE_GPU = true;

  MODEL_SPECS = 'vgg-16-encoder-decoder-contour';

  param = struct('base_lr', 0.00001, 'lr_policy', 'fixed', 'weight_decay', 0.001, 'solver_type', 3, 'snapshot_prefix', [outDir, '/', MODEL_SPECS]);

  make_solver_file(solver_prototxt, train_prototxt, param);

  matcaffe_fcn_vgg_init(USE_GPU, solver_prototxt, 0);

  if (weight)

    vggnet = load('../models/VGG_ILSVRC_16_layers_fcn_model.mat');

    weights0 = caffe('get_weights');
    for i=1:14, weights0(i).weights = vggnet.model(i).weights; end
    caffe('set_weights', weights0);

  end

  caffe('set_phase_train');

  imnames = textread(imNamesfile, '%s');
  length(imnames);

  H = 224; W = 224;

  fid = fopen([outDir, '/vgg-16-encoder-decoder-contour-w10-train-errors.txt'], 'w');

  mean_pix = [0.0, 0.0, 0.0];
  if (strcmpi('rgb', color))
    mean_pix = [103.939, 116.779, 123.68];
  end

  disp(['Mean: ', num2str(mean_pix)]);
  disp(['Color: ', color]);

  for iter = 1 : 60
    
    tic
    
    if mod(iter,5)==0

      weights = caffe('get_weights');
      save([outDir, '/', MODEL_SPECS, sprintf('-w10_model_iter%03d.mat', iter)], 'weights');

    end
    
    if iter==1

      weights = caffe('get_weights');
      save([outDir, '/', MODEL_SPECS, sprintf('-w10_model_iter%03d.mat', 0)], 'weights');

    end

    loss_train = 0;
    error_train_contour = 0;
   
    rnd_idx = randperm(length(imnames));

    for i = 1:length(imnames)

      name = imnames{rnd_idx(i)};

      im = imread([imDir, '/', name, '.jpg']);
      mask = imread([gtDir, '/', name, '.png']);

      im = color_convert(im, color);

      [ims, masks] = sample_image(im, mask);

      ims = ims(:,:,[3,2,1],:);

      for c = 1:3, ims(:,:,c,:) = ims(:,:,c,:) - mean_pix(c); end

      ims = permute(ims,[2,1,3,4]);

      contours = zeros(size(masks),'single');
      for k = 1:8, contours(:,:,:,k) = imgradient(masks(:,:,:,k))>0; end
      contours = permute(contours,[2,1,3,4]);

      output = caffe('forward', {ims});  

      penalties = single(contours); penalties(contours==0) = 0.1; penalties = 10*penalties;
      [loss_contour, delta_contour] = loss_crossentropy_paired_sigmoid_grad(output{1}, contours, penalties);
      delta_contour = reshape(single(delta_contour),[H,W,1,8]);

      caffe('backward', {delta_contour});
      caffe('update');

      loss_train = loss_train + loss_contour;
      contours_pred = output{1} > 0;
      error_train_contour = error_train_contour + sum(sum(sum(contours_pred~=contours)));

    end

    error_train_contour  = error_train_contour / length(imnames);
    loss_train = loss_train / length(imnames);

    fprintf('Iter %d: training error is %f with contour in %f seconds.\n', iter, error_train_contour, toc);

    fprintf(fid, '%d %f\n', iter, error_train_contour);

  end

  fclose(fid);
  caffe('snapshot');

end
