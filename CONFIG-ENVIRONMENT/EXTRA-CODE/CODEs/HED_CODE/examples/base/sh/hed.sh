set -e
export ONLY_PRINT_COMMANDS=false

##################################################################
# Configuration
##################################################################

# "RGB" "LUV" "LAB" "HSV" "YO1O2" "dRdGdB"
COLOR_CONF="LUV"

# number (1 to 4), 0 is test
FOLD_CONF=0

# "weigth_fixed_initialization_train" "weigth_random_initialization_train" "test"
METHODOLOGY_CONF="test"

# "pascal_context" "bsds500"
DATASET_CONF="pascal_context"

DATABASES_FULL_PATH_CONF="../../../data"
DEPLOY_PROTOTXT_CONF="../conf/deploy.prototxt"

# Full path to pdollar toolboxes
EVAL_CODE_TOOLBOX_CONF="../../../../../EVAL-CODE/toolbox/"
EVAL_CODE_EDGES_CONF="../../../../../EVAL-CODE/edges/"

# GT Images root folder
EVAL_GT_IMGS_ROOT_FOLDER_CONF="../../../../../EVAL-CODE/GT"

##################################################################
# Calculated configuration
##################################################################

DATASET_FOLDER_CONF=$DATABASES_FULL_PATH_CONF"/"$DATASET_CONF"/"

if [ "$DATASET_CONF" = "pascal_context" ]; then

    DATASET_IMAGES_TRAIN_LIST_CONF=$DATASET_FOLDER_CONF"train_pair-fold"$FOLD_CONF".lst"
    DATASET_IMAGES_TEST_LIST_CONF=$DATASET_FOLDER_CONF"test-fold"$FOLD_CONF".lst"

elif [ "$METHODOLOGY_CONF" = "bsds500" ]; then

    DATASET_IMAGES_TRAIN_LIST_CONF=$DATASET_FOLDER_CONF"train_pair.lst"
    DATASET_IMAGES_TEST_LIST_CONF=$DATASET_FOLDER_CONF"test.lst"

fi

if [ "$METHODOLOGY_CONF" = "weigth_random_initialization_train" ]; then

    SNAPSHOT_ITERATION_BEGIN_CONF=10000
    SNAPSHOT_ITERATION_STEP_CONF=$SNAPSHOT_ITERATION_BEGIN_CONF
    ITERATIONS_CONF=100000
    BASE_WEIGHTS_CONF=""
    SOLVER_STATE_CONF=""

elif [ "$METHODOLOGY_CONF" = "weigth_fixed_initialization_train" ]; then

    SNAPSHOT_ITERATION_BEGIN_CONF=10000
    SNAPSHOT_ITERATION_STEP_CONF=$SNAPSHOT_ITERATION_BEGIN_CONF
    ITERATIONS_CONF=10000
    BASE_WEIGHTS_CONF="../caffe_models/5stage-vgg.caffemodel"
    SOLVER_STATE_CONF=""

elif [ "$METHODOLOGY_CONF" = "test" ]; then

    SNAPSHOT_ITERATION_BEGIN_CONF=1
    SNAPSHOT_ITERATION_STEP_CONF=$SNAPSHOT_ITERATION_BEGIN_CONF
    ITERATIONS_CONF=10
    BASE_WEIGHTS_CONF=""
    SOLVER_STATE_CONF=""

fi

##################################################################
# Execution: Train
##################################################################

TOTAL_BEGIN_TIME=$SECONDS

echo '--------------------------------------------------------'
DATE=`date '+%Y-%m-%d %H:%M:%S'`
BEGIN_TIME=$SECONDS
echo -e "\n"[$DATE]" Begin train process.\n"

./train.sh $COLOR_CONF $DATASET_CONF $METHODOLOGY_CONF $FOLD_CONF $ITERATIONS_CONF $DATASET_FOLDER_CONF $DATASET_IMAGES_TRAIN_LIST_CONF $BASE_WEIGHTS_CONF $SOLVER_STATE_CONF || true

DATE=`date '+%Y-%m-%d %H:%M:%S'`
END_TIME=$SECONDS
echo -e "\n"[$DATE]" End train process. Elapsed: $(( END_TIME - BEGIN_TIME )) seconds.\n"
echo '--------------------------------------------------------'

##################################################################
# Execution: Test
##################################################################

echo '--------------------------------------------------------'
DATE=`date '+%Y-%m-%d %H:%M:%S'`
BEGIN_TIME=$SECONDS
echo -e "\n"[$DATE]" Begin boundary map generation.\n"

./test.sh $COLOR_CONF $DATASET_CONF $METHODOLOGY_CONF $FOLD_CONF $ITERATIONS_CONF $DATASET_FOLDER_CONF $DATASET_IMAGES_TEST_LIST_CONF $DEPLOY_PROTOTXT_CONF $SNAPSHOT_ITERATION_BEGIN_CONF $SNAPSHOT_ITERATION_STEP_CONF || true

DATE=`date '+%Y-%m-%d %H:%M:%S'`
END_TIME=$SECONDS
echo -e "\n"[$DATE]" End boundary map generation. Elapsed: $(( END_TIME - BEGIN_TIME )) seconds.\n"
echo '--------------------------------------------------------'

##################################################################
# Execution: Process boundary
##################################################################

echo '--------------------------------------------------------'
DATE=`date '+%Y-%m-%d %H:%M:%S'`
BEGIN_TIME=$SECONDS
echo -e "\n"[$DATE]" Begin process brute boudary detection maps.\n"

./process-brute.sh $COLOR_CONF $DATASET_CONF $METHODOLOGY_CONF $FOLD_CONF $ITERATIONS_CONF $SNAPSHOT_ITERATION_BEGIN_CONF $SNAPSHOT_ITERATION_STEP_CONF $EVAL_CODE_TOOLBOX_CONF $EVAL_CODE_EDGES_CONF

DATE=`date '+%Y-%m-%d %H:%M:%S'`
END_TIME=$SECONDS
echo -e "\n"[$DATE]" End process brute boudary detection maps. Elapsed: $(( END_TIME - BEGIN_TIME )) seconds.\n"
echo '--------------------------------------------------------'

##################################################################
# Execution: Process brute boudary detection maps
##################################################################

echo '--------------------------------------------------------'
DATE=`date '+%Y-%m-%d %H:%M:%S'`
BEGIN_TIME=$SECONDS
echo -e "\n"[$DATE]" Begin boudary detection maps evaluation.\n"

./eval.sh $COLOR_CONF $DATASET_CONF $METHODOLOGY_CONF $FOLD_CONF $ITERATIONS_CONF $SNAPSHOT_ITERATION_BEGIN_CONF $SNAPSHOT_ITERATION_STEP_CONF $EVAL_CODE_TOOLBOX_CONF $EVAL_CODE_EDGES_CONF $EVAL_GT_IMGS_ROOT_FOLDER_CONF

DATE=`date '+%Y-%m-%d %H:%M:%S'`
END_TIME=$SECONDS
echo -e "\n"[$DATE]" End boudary detection maps evaluation. Elapsed: $(( END_TIME - BEGIN_TIME )) seconds.\n"
echo '--------------------------------------------------------'

TOTAL_END_TIME=$SECONDS
echo -e "\nTotal elapsed: $(( TOTAL_END_TIME - TOTAL_BEGIN_TIME )) seconds.\n"
