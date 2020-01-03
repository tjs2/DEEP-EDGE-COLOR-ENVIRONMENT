set -e

for ITER in $(seq -f "%02g" $ITER_INIT $ITER_STEP $ITER_END)
do

    DATA_IMAGE_PATH_OUTPUT=$DATA_IMAGE_PATH_OUTPUT_FOLDER
    DATA_IMAGE_PATH_OUTPUT+=$DATA_IMAGE_PATH_OUTPUT_PREFIX
    DATA_IMAGE_PATH_OUTPUT+=$ITER
    DATA_IMAGE_PATH_OUTPUT+=$DATA_IMAGE_PATH_OUTPUT_PATH_SUFFIX

    if [ "$ONLY_PRINT_COMMANDS" = false ] ; then
        mkdir -p $DATA_IMAGE_PATH_OUTPUT
    fi

    PATH_MODEL_CAFFE_FILE=$PATH_MODEL_CAFFE
    PATH_MODEL_CAFFE_FILE+="/vgg-16-encoder-decoder-contour-w10-pascal-iter0"
    PATH_MODEL_CAFFE_FILE+=$ITER
    PATH_MODEL_CAFFE_FILE+=".caffemodel"

    CMD="python test.py"
    CMD+=" --prototxt   \""$PROTO_FILE_TEST"\""
    CMD+=" --caffemodel \""$PATH_MODEL_CAFFE_FILE"\""
    CMD+=" --imnames    \""$DATA_IMAGE_FILE_NAMES_TEST"\""
    CMD+=" --intput     \""$DATA_IMAGE_PATH_INPUT_TEST"\""
    CMD+=" --output     \""$DATA_IMAGE_PATH_OUTPUT"\""
    CMD+=" --color      \""$COLOR"\""

    echo -e "\n"$CMD"\n"

    if [ "$ONLY_PRINT_COMMANDS" = false ] ; then
        eval $CMD
    fi

done
