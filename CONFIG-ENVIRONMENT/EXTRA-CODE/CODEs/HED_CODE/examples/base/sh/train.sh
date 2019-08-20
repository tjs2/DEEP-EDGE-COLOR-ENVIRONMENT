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
echo ' . Iterations:' $5
echo ' . Dataset folder:' $6
echo ' . Dataset train list:' $7
echo ' . Base Weights:' $8
echo ' . Base solve state:' $9
echo

COLOR_PARAM=$1
DATASET_PARAM=$2
METHODOLOGY_PARAM=$3
FOLD_PARAM=$4
ITERATIONS_PARAM=$5
DATASET_FOLDER_PARAM=$6
DATASET_TRAIN_LIST_PARAM=$7
BASE_WEIGHTS_PARAM=$8
SOLVER_STATE_PARAM=$9

##################################################################
# Configuration
##################################################################

SUFFIX=hed-$DATASET_PARAM-$COLOR_PARAM-$METHODOLOGY_PARAM-fold$FOLD_PARAM

OUTPUT_FOLDER=../../$SUFFIX
mkdir -p $OUTPUT_FOLDER"/caffe_models"
pushd $PWD
cd $OUTPUT_FOLDER
OUTPUT_FOLDER=$PWD
popd

TRAIN_PROTOTXT=train-$SUFFIX.prototxt
SOLVER_PROTOTXT=solver-$SUFFIX.prototxt

TRAIN_PROTOTXT_PATH=$OUTPUT_FOLDER/$TRAIN_PROTOTXT
SOLVER_PROTOTXT_PATH=$OUTPUT_FOLDER/$SOLVER_PROTOTXT
SNAPSHOT_PREFIX_PATH=$OUTPUT_FOLDER/caffe_models/$SUFFIX

##################################################################
# Pre execution
##################################################################

TRAIN_PROTOTXT_BASE=$( < ../conf/train_$METHODOLOGY_PARAM.prototxt )
TRAIN_PROTOTXT_BASE=${TRAIN_PROTOTXT_BASE//\[COLOR_REPLACE\]/$COLOR_PARAM}
TRAIN_PROTOTXT_BASE=${TRAIN_PROTOTXT_BASE//\[DATASET_ROOT_FOLDER_REPLACE\]/$DATASET_FOLDER_PARAM}
TRAIN_PROTOTXT_BASE=${TRAIN_PROTOTXT_BASE//\[DATASET_TRAIN_PAIR_LIST_REPLACE\]/$DATASET_TRAIN_LIST_PARAM}

echo "$TRAIN_PROTOTXT_BASE" > $TRAIN_PROTOTXT_PATH

SOLVER_PROTOTXT_BASE=$( < ../conf/solver_$METHODOLOGY_PARAM.prototxt )
SOLVER_PROTOTXT_BASE=${SOLVER_PROTOTXT_BASE//\[TRAIN_PROTOTXT_REPLACE\]/$TRAIN_PROTOTXT_PATH}
SOLVER_PROTOTXT_BASE=${SOLVER_PROTOTXT_BASE//\[SNAPSHOT_PREFIX_REPLACE\]/$SNAPSHOT_PREFIX_PATH}

echo "$SOLVER_PROTOTXT_BASE" > $SOLVER_PROTOTXT_PATH

##################################################################
# Execution
##################################################################

CMD="python '../py/train.py'"
CMD+=" '"$SOLVER_PROTOTXT_PATH
CMD+="' '"$ITERATIONS_PARAM
CMD+="' '"$BASE_WEIGHTS_PARAM
CMD+="' '"$SOLVER_STATE_PARAM
CMD+="'"

echo -e "\n"$CMD"\n"

if [ "$ONLY_PRINT_COMMANDS" = false ] ; then
    eval $CMD
fi
