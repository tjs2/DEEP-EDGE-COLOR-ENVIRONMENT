function mat2caffe(iter, inDir, outDir, solver_prototxt, train_prototxt)

    SOLVER_STATE = '.solverstate';
    CAFFE_MODEL  = '.caffemodel';
    CAFFE_ITER_SNAPSHOT = '0';

    addpath( genpath('../caffe-cedn/matlab') );

    USE_GPU = true;

    MODEL_SPECS = 'vgg-16-encoder-decoder-contour';
    MODEL_OUT   = 'vgg-16-encoder-decoder-contour-w10-pascal-iter';

    param = struct('base_lr', 0.00001, 'lr_policy', 'fixed', 'weight_decay', 0.001, 'solver_type', 3, 'snapshot_prefix', [outDir, '/', MODEL_SPECS]);

    make_solver_file(solver_prototxt, train_prototxt, param);

    matcaffe_fcn_vgg_init(USE_GPU, solver_prototxt, 0);

    caffe('set_phase_train');

    disp([sprintf('\n\n'), 'Iteration: ', int2str(iter), sprintf('\n\n')]);

    load([inDir, '/', MODEL_SPECS, '-w10_model_iter', sprintf('%03d', iter), '.mat']);

    caffe('set_weights', weights);
    caffe('snapshot');

    oldName = [outDir, '/', MODEL_SPECS, '_iter_', CAFFE_ITER_SNAPSHOT];
    newName = [outDir, '/', MODEL_OUT, sprintf('%03d', iter)];

    movefile([oldName, SOLVER_STATE], [newName, SOLVER_STATE]);
    movefile([oldName,  CAFFE_MODEL], [newName,  CAFFE_MODEL]);

end

