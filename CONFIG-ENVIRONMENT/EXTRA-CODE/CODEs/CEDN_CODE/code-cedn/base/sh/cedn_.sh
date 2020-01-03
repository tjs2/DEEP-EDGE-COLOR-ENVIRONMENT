set -e

# Configuration
##################################################################

export ONLY_PRINT_COMMANDS=true

export BASE_DIR=$PWD

for COLOR_SELECTED in "LUV" "HSV" "YO1O2" "dRdGdB" "LAB";
do


export COLOR=$COLOR_SELECTED
#export METHODOLOGY="WEIGTH_FIXED_INITIALIZATION_NO_TRAIN"
#export METHODOLOGY="WEIGTH_FIXED_INITIALIZATION_TRAIN"
export METHODOLOGY="WEIGTH_RANDOM_INITIALIZATION_TRAIN"

if [ "$METHODOLOGY" = "WEIGTH_RANDOM_INITIALIZATION_TRAIN" ]; then
    export TRANSFER_WEIGHT=false
else
    export TRANSFER_WEIGHT=true
fi


for RUN_ITER in $(seq 1 1 1)
do


export ITER_INIT=5
export ITER_STEP=5
export ITER_END=60

export PROTO_FILE_TRAIN="PROTOTXTs/vgg-16-encoder-decoder-contour-pascal-train-"$METHODOLOGY".prototxt"
export PROTO_FILE_TEST="PROTOTXTs/vgg-16-encoder-decoder-contour-pascal-test.prototxt"
export PROTO_FILE_SOLVER="vgg-16-encoder-decoder-contour_solver.prototxt"

export DATA_IMAGE="PASCAL"
export DATA_IMAGE_FILE_NAMES_TEST="../data/PASCAL/val.txt"
export DATA_IMAGE_PATH_INPUT_TEST="../data/PASCAL/JPEGImages"

export DATA_IMAGE_FILE_NAMES_TRAIN="../data/PASCAL/train.txt"
export DATA_IMAGE_PATH_INPUT_TRAIN=$DATA_IMAGE_PATH_INPUT_TEST
export DATA_IMAGE_PATH_INPUT_GT="../data/PASCAL/SegmentationObjectFilledDenseCRF"

export DATA_IMAGE_PATH_OUTPUT_FOLDER="../results/CEDN-"$DATA_IMAGE"-"$COLOR"-"$METHODOLOGY"-"$RUN_ITER"/"
export DATA_IMAGE_PATH_OUTPUT_PREFIX="CEDN-"$DATA_IMAGE"-"
export DATA_IMAGE_PATH_OUTPUT_PATH_SUFFIX="-"$COLOR"-"$METHODOLOGY"-"$RUN_ITER

export PATH_MODEL_MAT="../models/CEDN-"$DATA_IMAGE"-"$COLOR"-"$METHODOLOGY"-"$RUN_ITER"/mat"
export PATH_MODEL_CAFFE="../models/CEDN-"$DATA_IMAGE"-"$COLOR"-"$METHODOLOGY"-"$RUN_ITER"/caffe"

export EVAL_PATH_CODE="/home/tjs2/Mestrado/CODE-EVAL/Eval-Code"
export EVAL_PATH_DATA_BURTE="/home/tjs2/Mestrado/CODE-EVAL/Eval-Code/data/bruteResDir"
export EVAL_PATH_DATA_EVAL="/home/tjs2/Mestrado/CODE-EVAL/Eval-Code/data/resDir"

# Run train
##################################################################

DATE=`date '+%Y-%m-%d %H:%M:%S'`
echo -e "\n"[$DATE]" Begin train process.\n"

./train.sh

DATE=`date '+%Y-%m-%d %H:%M:%S'`
echo -e "\n"[$DATE]" End train process.\n"

# Run conversion from matmodel to caffemodel
##################################################################

DATE=`date '+%Y-%m-%d %H:%M:%S'`
echo -e "\n"[$DATE]" Begin convert mat model to caffe model.\n"

./mat2caffe.sh

DATE=`date '+%Y-%m-%d %H:%M:%S'`
echo -e "\n"[$DATE]" End convert mat model to caffe model.\n"

# Run boundary map generation
##################################################################

DATE=`date '+%Y-%m-%d %H:%M:%S'`
echo -e "\n"[$DATE]" Begin boundary map generation.\n"

./test.sh

DATE=`date '+%Y-%m-%d %H:%M:%S'`
echo -e "\n"[$DATE]" End boundary map generation.\n"

# Run process brute boudary detection maps
##################################################################

DATE=`date '+%Y-%m-%d %H:%M:%S'`
echo -e "\n"[$DATE]" Begin process brute boudary detection maps.\n"

./process-brute.sh

DATE=`date '+%Y-%m-%d %H:%M:%S'`
echo -e "\n"[$DATE]" End process brute boudary detection maps.\n"

# Run boudary detection maps evaluation
##################################################################

DATE=`date '+%Y-%m-%d %H:%M:%S'`
echo -e "\n"[$DATE]" Begin boudary detection maps evaluation.\n"

#./eval.sh

DATE=`date '+%Y-%m-%d %H:%M:%S'`
echo -e "\n"[$DATE]" End boudary detection maps evaluation.\n"

##################################################################


done
done