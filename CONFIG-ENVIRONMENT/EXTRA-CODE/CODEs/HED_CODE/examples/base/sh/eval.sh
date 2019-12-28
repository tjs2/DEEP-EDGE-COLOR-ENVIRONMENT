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

echo 'Eval parameters:'

echo ' . Color:' $1
echo ' . Dataset:' $2
echo ' . Methodology:' $3
echo ' . Fold:' $4
echo ' . Iterations:' $5
echo ' . Snapshot begin:' $6
echo ' . Snapshot step:' $7
echo ' . Eval code edge:' $8
echo ' . Eval code toolbox:' $9
echo ' . Eval GT root folder:' ${10}
echo

COLOR_PARAM=$1
DATASET_PARAM=$2
METHODOLOGY_PARAM=$3
FOLD_PARAM=$4
ITERATIONS_PARAM=$5
SNAPSHOT_BEGIN_PARAM=$6
SNAPSHOT_STEP_PARAM=$7
EVAL_CODE_TOOLBOX_PARAM=$8
EVAL_CODE_EDGES_PARAM=$9
EVAL_GT_IMGS_ROOT_FOLDER_PARAM=${10}

##################################################################
# Configuration
##################################################################

SUFFIX="hed-"$DATASET_PARAM"-"$COLOR_PARAM"-"$METHODOLOGY_PARAM"-fold"$FOLD_PARAM

OUTPUT_FOLDER="../../"$SUFFIX
mkdir -p $OUTPUT_FOLDER
pushd $PWD
cd $OUTPUT_FOLDER
OUTPUT_FOLDER=$PWD
popd

MATLAB_FOLDER="../matlab"
pushd $PWD
cd $MATLAB_FOLDER
MATLAB_FOLDER=$PWD
popd

##################################################################
# Execution
##################################################################

for ITER in $(seq $SNAPSHOT_BEGIN_PARAM $SNAPSHOT_STEP_PARAM $ITERATIONS_PARAM)
do

    FOLDER_TO_EVAL=$SUFFIX"-iter_"$ITER
    FINAL_RESULT_DIR=$OUTPUT_FOLDER"/result/resDir/"
    GT_IMAGES_DIR=$EVAL_GT_IMGS_ROOT_FOLDER_PARAM"/"$DATASET_PARAM"/fold"$FOLD_PARAM"/"

    CMD="matlab -nodisplay -r \""
    CMD+="cd('"$MATLAB_FOLDER"'); "
    CMD+="addpath(genpath('"$EVAL_CODE_TOOLBOX_PARAM"')); "
    CMD+="addpath(genpath('"$EVAL_CODE_EDGES_PARAM"')); "
    CMD+="evaluation({'"$FOLDER_TO_EVAL"'}, '"$FINAL_RESULT_DIR"', '"$GT_IMAGES_DIR"'); "
    CMD+="exit\""

    echo -e "\n"$CMD"\n"

    if [ "$ONLY_PRINT_COMMANDS" = false ] ; then
        eval $CMD
    fi

done
