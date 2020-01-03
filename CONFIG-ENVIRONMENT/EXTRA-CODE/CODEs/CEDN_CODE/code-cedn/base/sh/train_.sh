set -e

if [ "$ONLY_PRINT_COMMANDS" = false ] ; then
    mkdir -p $PATH_MODEL_MAT
fi

CMD="matlab -nodisplay -r \""
CMD+="cd('"$BASE_DIR"'); "
CMD+="train('"$PROTO_FILE_SOLVER
CMD+="', '"$PROTO_FILE_TRAIN
CMD+="', "$TRANSFER_WEIGHT
CMD+=", '"$PATH_MODEL_MAT
CMD+="', '"$DATA_IMAGE_FILE_NAMES_TRAIN
CMD+="', '"$DATA_IMAGE_PATH_INPUT_TRAIN
CMD+="', '"$DATA_IMAGE_PATH_INPUT_GT
CMD+="', '"$COLOR"'); "
CMD+="exit\""

echo -e "\n"$CMD"\n"

if [ "$ONLY_PRINT_COMMANDS" = false ] ; then
    eval $CMD
fi
