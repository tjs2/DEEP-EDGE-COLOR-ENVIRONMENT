set -e
export ONLY_PRINT_COMMANDS=false

##################################################################
# Configuration
##################################################################

# "RGB" "LUV" "LAB" "HSV" "YO1O2" "dRdGdB"
COLOR_CONF="LUV"

# number (1 to 4), 0 is test
FOLD_CONF=0

# "WEIGTH_FIXED_INITIALIZATION_NO_TRAIN" "WEIGTH_FIXED_INITIALIZATION_TRAIN" "WEIGTH_RANDOM_INITIALIZATION_TRAIN" "TEST"
METHODOLOGY_CONF="TEST"

# "pascal_context"
DATASET_CONF="pascal_context"

DATABASES_FULL_PATH_CONF="../../../data"
###############################################
#DEPLOY_PROTOTXT_CONF="../conf/deploy.prototxt"
###############################################

# Full path to pdollar toolboxes
EVAL_CODE_TOOLBOX_CONF="../../../../../EVAL-CODE/toolbox/"
EVAL_CODE_EDGES_CONF="../../../../../EVAL-CODE/edges/"

# GT Images root folder
EVAL_GT_IMGS_ROOT_FOLDER_CONF="../../../../../EVAL-CODE/GT"

##################################################################
# Calculated configuration
##################################################################

DATASET_FOLDER_CONF=$DATABASES_FULL_PATH_CONF"/"$DATASET_CONF"/"
pushd $PWD
cd $DATASET_FOLDER_CONF
DATASET_FOLDER_CONF=$PWD
popd

DATASET_IMAGES_TRAIN_NAMES_CONF=$DATASET_FOLDER_CONF"train-fold"$FOLD_CONF".txt"
DATASET_IMAGES_TEST_NAMES_CONF=$DATASET_FOLDER_CONF"test-fold"$FOLD_CONF".txt"

if [ "$METHODOLOGY_CONF" = "WEIGTH_RANDOM_INITIALIZATION_TRAIN" ]; then

    SNAPSHOT_EPOCH_BEGIN_CONF=5
    SNAPSHOT_ITERATION_STEP_CONF=$SNAPSHOT_EPOCH_BEGIN_CONF
    EPOCH_CONF=60

elif [ "$METHODOLOGY_CONF" = "WEIGTH_FIXED_INITIALIZATION_NO_TRAIN" || ["$METHODOLOGY_CONF" = "WEIGTH_FIXED_INITIALIZATION_TRAIN" ]; then

    SNAPSHOT_EPOCH_BEGIN_CONF=5
    SNAPSHOT_ITERATION_STEP_CONF=$SNAPSHOT_EPOCH_BEGIN_CONF
    EPOCH_CONF=30
    BASE_WEIGHTS_CONF=""

elif [ "$METHODOLOGY_CONF" = "TEST" ]; then

    SNAPSHOT_EPOCH_BEGIN_CONF=1
    SNAPSHOT_ITERATION_STEP_CONF=$SNAPSHOT_EPOCH_BEGIN_CONF
    EPOCH_CONF=5
    BASE_WEIGHTS_CONF=""

fi

##################################################################
# Execution: Train
##################################################################

TOTAL_BEGIN_TIME=$SECONDS

echo '--------------------------------------------------------'
DATE=`date '+%Y-%m-%d %H:%M:%S'`
BEGIN_TIME=$SECONDS
ECHO_CONTENT_BEGIN="\n"[$DATE]" Begin train process.\n"
echo -e $ECHO_CONTENT_BEGIN

CMD="bash ./train.sh $COLOR_CONF $DATASET_CONF $METHODOLOGY_CONF $FOLD_CONF $EPOCH_CONF $DATASET_FOLDER_CONF $DATASET_IMAGES_TRAIN_NAMES_CONF $BASE_WEIGHTS_CONF || true"
eval $CMD

DATE=`date '+%Y-%m-%d %H:%M:%S'`
END_TIME=$SECONDS
ECHO_CONTENT_END="\n"[$DATE]" End train process. Elapsed: $(( END_TIME - BEGIN_TIME )) seconds.\n"
echo -e $ECHO_CONTENT_END
echo '--------------------------------------------------------'

bash ./send-mail.sh $MAIL_SUBJECT " . Machine: <br>$HOSTNAME<br> . Begin: ${ECHO_CONTENT_BEGIN//"\n"/\<br\>} . End: ${ECHO_CONTENT_END//"\n"/\<br\>} . CMD: <br>${CMD//"\n"/\<br\>}<br>"

##################################################################
# Execution: Test
##################################################################