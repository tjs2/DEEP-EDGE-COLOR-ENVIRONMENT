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

echo 'Test parameters:'

echo ' . Color:' $1
echo ' . Dataset:' $2
echo ' . Methodology:' $3
echo ' . Fold:' $4
echo ' . Iterations:' $5
echo ' . Dataset folder:' $6
echo ' . Dataset test list:' $7
echo ' . Deploy prototxt:' $8
echo ' . Snapshot begin:' $9
echo ' . Snapshot step:' ${10}
echo

COLOR_PARAM=$1
DATASET_PARAM=$2
METHODOLOGY_PARAM=$3
FOLD_PARAM=$4
ITERATIONS_PARAM=$5
DATASET_FOLDER_PARAM=$6
DATASET_TEST_LIST_PARAM=$7
DEPLOY_PROTOTXT_PARAM=$8
SNAPSHOT_BEGIN_PARAM=$9
SNAPSHOT_STEP_PARAM=${10}

##################################################################
# Configuration
##################################################################

SUFFIX=hed-$DATASET_PARAM-$COLOR_PARAM-$METHODOLOGY_PARAM-fold$FOLD_PARAM

OUTPUT_FOLDER=../../$SUFFIX
mkdir -p $OUTPUT_FOLDER
pushd $PWD
cd $OUTPUT_FOLDER
OUTPUT_FOLDER=$PWD
popd

##################################################################
# Execution
##################################################################

for ITER in $(seq $SNAPSHOT_BEGIN_PARAM $SNAPSHOT_STEP_PARAM $ITERATIONS_PARAM)
do

    RESULT_FOLDER=$OUTPUT_FOLDER"/result/bruteResDir/"$SUFFIX"-iter_"$ITER"/IN/"
    CAFFE_MODEL=$OUTPUT_FOLDER"/caffe_models/"$SUFFIX"_iter_"$ITER".caffemodel"

    CMD="python '../py/test.py'"
    CMD+=" '"$COLOR_PARAM

    CMD+="' '"$DATASET_FOLDER_PARAM
    CMD+="' '"$DATASET_TEST_LIST_PARAM
    CMD+="' '"$DEPLOY_PROTOTXT_PARAM

    CMD+="' '"$RESULT_FOLDER
    CMD+="' '"$CAFFE_MODEL
    CMD+="'"
    CMD+=" || true"

    echo -e "\n"$CMD"\n"

    if [ "$ONLY_PRINT_COMMANDS" = false ] ; then
        eval $CMD
    fi

done
