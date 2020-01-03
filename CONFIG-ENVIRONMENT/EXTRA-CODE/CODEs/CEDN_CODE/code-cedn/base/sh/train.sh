set -e

pushd () {
    command pushd "$@" > /dev/null
}

popd () {
    command popd "$@" > /dev/null
}

##################################################################
# Parameters
##################################################################

echo 'Train parameters:'
echo ' . Color:' $1
echo ' . Dataset:' $2
echo ' . Methodology:' $3
echo ' . Fold:' $4
echo ' . Epochs:' $5
echo ' . Dataset folder:' $6
echo ' . Dataset image names:' $7
echo ' . Base Weights:' $8
echo

COLOR_PARAM=$1
DATASET_PARAM=$2
METHODOLOGY_PARAM=$3
FOLD_PARAM=$4
EPOCHS_PARAM=$5
DATASET_FOLDER_PARAM=$6
DATASET_IMAGE_NAMES_PARAM=$7
BASE_WEIGHTS_PARAM=$8

##################################################################
# Configuration
##################################################################

SUFFIX=cedn-$DATASET_PARAM-$COLOR_PARAM-$METHODOLOGY_PARAM-fold$FOLD_PARAM

OUTPUT_FOLDER=../../$SUFFIX
mkdir -p $OUTPUT_FOLDER"/mat_models"
pushd $PWD
cd $OUTPUT_FOLDER
OUTPUT_FOLDER=$PWD
popd

MATLAB_FOLDER=../matlab
pushd $PWD
cd $MATLAB_FOLDER
MATLAB_FOLDER=$PWD
popd

TRAIN_PROTOTXT=train-$SUFFIX.prototxt
SOLVER_PROTOTXT=solver-$SUFFIX.prototxt

TRAIN_PROTOTXT_PATH=$OUTPUT_FOLDER/$TRAIN_PROTOTXT
SOLVER_PROTOTXT_PATH=$OUTPUT_FOLDER/$SOLVER_PROTOTXT
SNAPSHOT_PREFIX_PATH=$OUTPUT_FOLDER/mat_models/$SUFFIX

if [ "$METHODOLOGY_PARAM" = "WEIGTH_RANDOM_INITIALIZATION_TRAIN" ]; then
    export TRANSFER_WEIGHT=false
else
    export TRANSFER_WEIGHT=true
fi

DATASET_TRAIN_FOLDER=$DATASET_FOLDER_PARAM"img/"
DATASET_GT_FOLDER=$DATASET_FOLDER_PARAM"rg/"

##################################################################
# Pre execution
##################################################################

#TRAIN_PROTOTXT_BASE=$( < ../conf/train_$METHODOLOGY_PARAM.prototxt )
#TRAIN_PROTOTXT_BASE=${TRAIN_PROTOTXT_BASE//\[COLOR_REPLACE\]/$COLOR_PARAM}
#TRAIN_PROTOTXT_BASE=${TRAIN_PROTOTXT_BASE//\[DATASET_ROOT_FOLDER_REPLACE\]/$DATASET_FOLDER_PARAM}
#TRAIN_PROTOTXT_BASE=${TRAIN_PROTOTXT_BASE//\[DATASET_TRAIN_PAIR_LIST_REPLACE\]/$DATASET_TRAIN_NAMES_PARAM}
#
#echo "$TRAIN_PROTOTXT_BASE" > $TRAIN_PROTOTXT_PATH
#
#SOLVER_PROTOTXT_BASE=$( < ../conf/solver_$METHODOLOGY_PARAM.prototxt )
#SOLVER_PROTOTXT_BASE=${SOLVER_PROTOTXT_BASE//\[TRAIN_PROTOTXT_REPLACE\]/$TRAIN_PROTOTXT_PATH}
#SOLVER_PROTOTXT_BASE=${SOLVER_PROTOTXT_BASE//\[SNAPSHOT_PREFIX_REPLACE\]/$SNAPSHOT_PREFIX_PATH}
#
#echo "$SOLVER_PROTOTXT_BASE" > $SOLVER_PROTOTXT_PATH

##################################################################
# Execution
##################################################################

CMD="matlab -nodisplay -r \""
CMD+="cd('"$MATLAB_FOLDER"'); "
CMD+="train('"$SOLVER_PROTOTXT_PATH
CMD+="', '"$TRAIN_PROTOTXT_PATH
CMD+="', "$TRANSFER_WEIGHT
CMD+=", '"$OUTPUT_FOLDER"/mat_models"
CMD+="', '"$DATASET_IMAGE_NAMES_PARAM
CMD+="', '"$DATASET_TRAIN_FOLDER
CMD+="', '"$DATASET_GT_FOLDER
CMD+="', '"$COLOR_PARAM"'); "
CMD+="exit\""

echo -e "\n"$CMD"\n"

if [ "$ONLY_PRINT_COMMANDS" = false ] ; then
    eval $CMD
fi
