set -e

for ITER in $(seq -f "%02g" $ITER_INIT $ITER_STEP $ITER_END)
do

    DATA_IMAGE_PATH_TO_EVAL=$DATA_IMAGE_PATH_OUTPUT_PREFIX
    DATA_IMAGE_PATH_TO_EVAL+=$ITER
    DATA_IMAGE_PATH_TO_EVAL+=$DATA_IMAGE_PATH_OUTPUT_PATH_SUFFIX

    CMD="matlab -nodisplay -r \""
    CMD+="cd('"$EVAL_PATH_CODE"'); "
    CMD+="evaluation({'"$DATA_IMAGE_PATH_TO_EVAL"'}); "
    CMD+="exit\""

    echo -e "\n"$CMD"\n"

    if [ "$ONLY_PRINT_COMMANDS" = false ] ; then
        eval $CMD
    fi

done
