set -e

if [ "$ONLY_PRINT_COMMANDS" = false ] ; then
    mkdir -p $PATH_MODEL_CAFFE
fi

for ITER in $(seq -f "%02g" $ITER_INIT $ITER_STEP $ITER_END)
do

    CMD="matlab -nodisplay -r \""
    CMD+="cd('"$BASE_DIR"'); "
    CMD+="mat2caffe("$ITER", '"$PATH_MODEL_MAT"', '"$PATH_MODEL_CAFFE"', '"$PROTO_FILE_SOLVER"', '"$PROTO_FILE_TRAIN"'); "
    CMD+="exit\""

    echo -e "\n"$CMD"\n"

    if [ "$ONLY_PRINT_COMMANDS" = false ] ; then
        eval $CMD
    fi

done
