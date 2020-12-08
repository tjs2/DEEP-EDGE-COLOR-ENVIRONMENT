set -e

pushd () {
    command pushd "$@" > /dev/null
}

popd () {
    command popd "$@" > /dev/null
}

#####################################################################################
# CONFIG
#####################################################################################

ENVIRONMENT_FOLDER_CONF="DEEP-EDGE-COLOR"

# DATABASEs

DATABASE_FOLDER_NAME_CONF="DATABASEs"
DATABASE_FOLDER_CONF="../"$ENVIRONMENT_FOLDER_CONF"/"$DATABASE_FOLDER_NAME_CONF

PASCAL_CONTEXT_URL_CONF="https://www.dropbox.com/s/m87yv50pj9vw774/pascal_context.zip?dl=0"
BSDS500_URL_CONF="https://www.dropbox.com/s/rhg0b43wp04am3h/bsds500.zip?dl=0"

PASCAL_CONTEXT_NAME_CONF="pascal_context"
BSDS500_NAME_CONF="bsds500"

# EVAL-CODE

EVAL_FOLDER_CONF="../"$ENVIRONMENT_FOLDER_CONF"/EVAL-CODE"

GT_URL_CONF="https://www.dropbox.com/s/akuwc8fp2xqmcsa/GT.zip?dl=0"

PDOLLAR_EDGES_URL_CONF="https://github.com/tjs2/edges.git"
PDOLLAR_TOOLBOX_URL_CONF="https://github.com/tjs2/toolbox.git"

PDOLLAR_EDGES_FOLDER_CONF="edges"
PDOLLAR_TOOLBOX_FOLDER_CONF="toolbox"

# CODEs

CODES_FOLDER_CONF="../"$ENVIRONMENT_FOLDER_CONF"/CODEs"

HED_CODE_GIT_URL_CONF="https://github.com/tjs2/hed.git"
CEDN_CODE_GIT_URL_CONF="https://github.com/tjs2/objectContourDetector.git"

HED_CODE_GIT_BRANCH_CONF="hed-color"
CEDN_CODE_GIT_BRANCH_CONF="cedn-color"

HED_CODE_FOLDER_CONF="HED_CODE"
CEDN_CODE_FOLDER_CONF="CEDN_CODE"

# MODELs

MODELS_FOLDER_CONF="../"$ENVIRONMENT_FOLDER_CONF"/MODELs"

HED_MODEL_URL_CONF="https://www.dropbox.com/s/bm30ijdh5skwhqv/5stage-vgg.caffemodel?dl=0"
CEDN_MODEL_URL_CONF="https://www.dropbox.com/s/ol5itrbloahff6r/VGG_ILSVRC_16_layers_fcn_model.mat?dl=0"

HED_MODEL_NAME_CONF="5stage-vgg.caffemodel"
CEDN_MODEL_NAME_CONF="VGG_ILSVRC_16_layers_fcn_model.mat"

#####################################################################################
# RUN
#####################################################################################

# DATABASEs

mkdir -p $DATABASE_FOLDER_CONF

wget -O $DATABASE_FOLDER_CONF"/"$BSDS500_NAME_CONF".zip" $BSDS500_URL_CONF
wget -O $DATABASE_FOLDER_CONF"/"$PASCAL_CONTEXT_NAME_CONF".zip" $PASCAL_CONTEXT_URL_CONF

unzip $DATABASE_FOLDER_CONF"/"$PASCAL_CONTEXT_NAME_CONF".zip"  -d $DATABASE_FOLDER_CONF"/"$PASCAL_CONTEXT_NAME_CONF"/"
unzip $DATABASE_FOLDER_CONF"/"$BSDS500_NAME_CONF".zip" -d $DATABASE_FOLDER_CONF"/"$BSDS500_NAME_CONF"/"

# EVAL-CODE

mkdir -p $EVAL_FOLDER_CONF

git clone $PDOLLAR_EDGES_URL_CONF $EVAL_FOLDER_CONF"/"$PDOLLAR_EDGES_FOLDER_CONF
git clone $PDOLLAR_TOOLBOX_URL_CONF $EVAL_FOLDER_CONF"/"$PDOLLAR_TOOLBOX_FOLDER_CONF

wget -O $EVAL_FOLDER_CONF"/GT.zip" $GT_URL_CONF
unzip $EVAL_FOLDER_CONF"/GT.zip" -d $EVAL_FOLDER_CONF"/"$GT"/"

# CODEs

mkdir -p $CODES_FOLDER_CONF

git clone $HED_CODE_GIT_URL_CONF $CODES_FOLDER_CONF"/"$HED_CODE_FOLDER_CONF
git -C $CODES_FOLDER_CONF"/"$HED_CODE_FOLDER_CONF checkout -B $HED_CODE_GIT_BRANCH_CONF "origin/"$HED_CODE_GIT_BRANCH_CONF

git clone $CEDN_CODE_GIT_URL_CONF $CODES_FOLDER_CONF"/"$CEDN_CODE_FOLDER_CONF
git -C $CODES_FOLDER_CONF"/"$CEDN_CODE_FOLDER_CONF checkout -B $CEDN_CODE_GIT_BRANCH_CONF "origin/"$CEDN_CODE_GIT_BRANCH_CONF

# MODELs

mkdir -p $MODELS_FOLDER_CONF

wget -O $MODELS_FOLDER_CONF"/"$HED_MODEL_NAME_CONF $HED_MODEL_URL_CONF
wget -O $MODELS_FOLDER_CONF"/"$CEDN_MODEL_NAME_CONF $CEDN_MODEL_URL_CONF

mkdir -p $CODES_FOLDER_CONF"/"$HED_CODE_FOLDER_CONF"/data/"
cp -f $MODELS_FOLDER_CONF"/"$HED_MODEL_NAME_CONF $CODES_FOLDER_CONF"/"$HED_CODE_FOLDER_CONF"/data/"

mkdir -p $CODES_FOLDER_CONF"/"$CEDN_CODE_FOLDER_CONF"/data/"
cp -f $MODELS_FOLDER_CONF"/"$CEDN_MODEL_NAME_CONF $CODES_FOLDER_CONF"/"$CEDN_CODE_FOLDER_CONF"/data/"

#####################################################################################
# EXTEND
#####################################################################################

# DATABASEs

# DATABASE - PASCAL CONTEXT - HED

pushd $PWD
cd $DATABASE_FOLDER_CONF"/"$PASCAL_CONTEXT_NAME_CONF"/"

ln -fs "../../../CONFIG-ENVIRONMENT/EXTRA-CODE/DATABASEs/pascal_context/test-fold0.lst" "test-fold0.lst"
ln -fs "../../../CONFIG-ENVIRONMENT/EXTRA-CODE/DATABASEs/pascal_context/test-fold1.lst" "test-fold1.lst"
ln -fs "../../../CONFIG-ENVIRONMENT/EXTRA-CODE/DATABASEs/pascal_context/test-fold2.lst" "test-fold2.lst"
ln -fs "../../../CONFIG-ENVIRONMENT/EXTRA-CODE/DATABASEs/pascal_context/test-fold3.lst" "test-fold3.lst"
ln -fs "../../../CONFIG-ENVIRONMENT/EXTRA-CODE/DATABASEs/pascal_context/test-fold4.lst" "test-fold4.lst"
ln -fs "../../../CONFIG-ENVIRONMENT/EXTRA-CODE/DATABASEs/pascal_context/test-fold5.lst" "test-fold5.lst"

ln -fs "../../../CONFIG-ENVIRONMENT/EXTRA-CODE/DATABASEs/pascal_context/train_pair-fold0.lst" "train_pair-fold0.lst"
ln -fs "../../../CONFIG-ENVIRONMENT/EXTRA-CODE/DATABASEs/pascal_context/train_pair-fold1.lst" "train_pair-fold1.lst"
ln -fs "../../../CONFIG-ENVIRONMENT/EXTRA-CODE/DATABASEs/pascal_context/train_pair-fold2.lst" "train_pair-fold2.lst"
ln -fs "../../../CONFIG-ENVIRONMENT/EXTRA-CODE/DATABASEs/pascal_context/train_pair-fold3.lst" "train_pair-fold3.lst"
ln -fs "../../../CONFIG-ENVIRONMENT/EXTRA-CODE/DATABASEs/pascal_context/train_pair-fold4.lst" "train_pair-fold4.lst"
ln -fs "../../../CONFIG-ENVIRONMENT/EXTRA-CODE/DATABASEs/pascal_context/train_pair-fold5.lst" "train_pair-fold5.lst"

# DATABASE - PASCAL CONTEXT - CEDN

ln -fs "../../../CONFIG-ENVIRONMENT/EXTRA-CODE/DATABASEs/pascal_context/test-fold0.txt" "test-fold0.txt"
ln -fs "../../../CONFIG-ENVIRONMENT/EXTRA-CODE/DATABASEs/pascal_context/test-fold1.txt" "test-fold1.txt"
ln -fs "../../../CONFIG-ENVIRONMENT/EXTRA-CODE/DATABASEs/pascal_context/test-fold2.txt" "test-fold2.txt"
ln -fs "../../../CONFIG-ENVIRONMENT/EXTRA-CODE/DATABASEs/pascal_context/test-fold3.txt" "test-fold3.txt"
ln -fs "../../../CONFIG-ENVIRONMENT/EXTRA-CODE/DATABASEs/pascal_context/test-fold4.txt" "test-fold4.txt"
ln -fs "../../../CONFIG-ENVIRONMENT/EXTRA-CODE/DATABASEs/pascal_context/test-fold5.txt" "test-fold5.txt"

ln -fs "../../../CONFIG-ENVIRONMENT/EXTRA-CODE/DATABASEs/pascal_context/train-fold0.txt" "train-fold0.txt"
ln -fs "../../../CONFIG-ENVIRONMENT/EXTRA-CODE/DATABASEs/pascal_context/train-fold1.txt" "train-fold1.txt"
ln -fs "../../../CONFIG-ENVIRONMENT/EXTRA-CODE/DATABASEs/pascal_context/train-fold2.txt" "train-fold2.txt"
ln -fs "../../../CONFIG-ENVIRONMENT/EXTRA-CODE/DATABASEs/pascal_context/train-fold3.txt" "train-fold3.txt"
ln -fs "../../../CONFIG-ENVIRONMENT/EXTRA-CODE/DATABASEs/pascal_context/train-fold4.txt" "train-fold4.txt"
ln -fs "../../../CONFIG-ENVIRONMENT/EXTRA-CODE/DATABASEs/pascal_context/train-fold5.txt" "train-fold5.txt"

popd

# DATABASE - BSDS500 - HED

pushd $PWD
cd $DATABASE_FOLDER_CONF"/"$BSDS500_NAME_CONF"/"

ln -fs "../../../CONFIG-ENVIRONMENT/EXTRA-CODE/DATABASEs/bsds500/test-fold1.lst" "test-fold1.lst"
ln -fs "../../../CONFIG-ENVIRONMENT/EXTRA-CODE/DATABASEs/bsds500/train_pair-fold1.lst" "train_pair-fold1.lst"

popd

# EVAL-CODE

pushd $PWD
cd $EVAL_FOLDER_CONF"/"$PDOLLAR_EDGES_FOLDER_CONF"/private/"
cp -f *.mexa64 ../
cp -f *.mexw64 ../
popd

# CODEs

# CODE - HED

mkdir -p $CODES_FOLDER_CONF"/"$HED_CODE_FOLDER_CONF"/data/"
pushd $PWD
cd $CODES_FOLDER_CONF"/"$HED_CODE_FOLDER_CONF"/data/"
ln -fs "../../../"$DATABASE_FOLDER_NAME_CONF"/"$PASCAL_CONTEXT_NAME_CONF"/" $PASCAL_CONTEXT_NAME_CONF
ln -fs "../../../"$DATABASE_FOLDER_NAME_CONF"/"$BSDS500_NAME_CONF"/" $BSDS500_NAME_CONF
popd

pushd $PWD
cd $CODES_FOLDER_CONF"/"$HED_CODE_FOLDER_CONF"/examples/"

mkdir -p "./base/conf"
cd "./base/conf"
ln -fs "../../../../../../CONFIG-ENVIRONMENT/EXTRA-CODE/CODEs/HED_CODE/examples/base/conf/deploy.prototxt" "deploy.prototxt"
ln -fs "../../../../../../CONFIG-ENVIRONMENT/EXTRA-CODE/CODEs/HED_CODE/examples/base/conf/solver_test.prototxt" "solver_test.prototxt"
ln -fs "../../../../../../CONFIG-ENVIRONMENT/EXTRA-CODE/CODEs/HED_CODE/examples/base/conf/solver_weigth_random_initialization_train.prototxt" "solver_weigth_random_initialization_train.prototxt"
ln -fs "../../../../../../CONFIG-ENVIRONMENT/EXTRA-CODE/CODEs/HED_CODE/examples/base/conf/train_test.prototxt" "train_test.prototxt"
ln -fs "../../../../../../CONFIG-ENVIRONMENT/EXTRA-CODE/CODEs/HED_CODE/examples/base/conf/train_weigth_fixed_initialization_train.prototxt" "train_weigth_fixed_initialization_train.prototxt"
ln -fs "../../../../../../CONFIG-ENVIRONMENT/EXTRA-CODE/CODEs/HED_CODE/examples/base/conf/train_weigth_random_initialization_train.prototxt" "train_weigth_random_initialization_train.prototxt"
cd "../../"

mkdir -p "./base/matlab"
cd "./base/matlab"
ln -fs "../../../../../../CONFIG-ENVIRONMENT/EXTRA-CODE/CODEs/HED_CODE/examples/base/matlab/evaluation.m" "evaluation.m"
ln -fs "../../../../../../CONFIG-ENVIRONMENT/EXTRA-CODE/CODEs/HED_CODE/examples/base/matlab/process_brute_data_hed.m" "process_brute_data_hed.m"
ln -fs "../../../../../../CONFIG-ENVIRONMENT/EXTRA-CODE/CODEs/HED_CODE/examples/base/matlab/thinning.m" "thinning.m"
cd "../../"

mkdir -p "./base/py"
cd "./base/py"
ln -fs "../../../../../../CONFIG-ENVIRONMENT/EXTRA-CODE/CODEs/HED_CODE/examples/base/py/colorspace.py" "colorspace.py"
ln -fs "../../../../../../CONFIG-ENVIRONMENT/EXTRA-CODE/CODEs/HED_CODE/examples/base/py/test.py" "test.py"
ln -fs "../../../../../../CONFIG-ENVIRONMENT/EXTRA-CODE/CODEs/HED_CODE/examples/base/py/train.py" "train.py"
cd "../../"

mkdir -p "./base/sh"
cd "./base/sh"
ln -fs "../../../../../../CONFIG-ENVIRONMENT/EXTRA-CODE/CODEs/HED_CODE/examples/base/sh/eval.sh" "eval.sh"
ln -fs "../../../../../../CONFIG-ENVIRONMENT/EXTRA-CODE/CODEs/HED_CODE/examples/base/sh/hed.sh" "hed.sh"
ln -fs "../../../../../../CONFIG-ENVIRONMENT/EXTRA-CODE/CODEs/HED_CODE/examples/base/sh/process-brute.sh" "process-brute.sh"
ln -fs "../../../../../../CONFIG-ENVIRONMENT/EXTRA-CODE/CODEs/HED_CODE/examples/base/sh/run.sh" "run.sh"
ln -fs "../../../../../../CONFIG-ENVIRONMENT/EXTRA-CODE/CODEs/HED_CODE/examples/base/sh/test.sh" "test.sh"
ln -fs "../../../../../../CONFIG-ENVIRONMENT/EXTRA-CODE/CODEs/HED_CODE/examples/base/sh/train.sh" "train.sh"
ln -fs "../../../../../../CONFIG-ENVIRONMENT/EXTRA-CODE/CODEs/HED_CODE/examples/base/sh/send-mail.sh" "send-mail.sh"
cd "../../"

mkdir -p "./base/java"
cd "./base/java"
ln -fs "../../../../../../CONFIG-ENVIRONMENT/EXTRA-CODE/CODEs/HED_CODE/examples/base/java/mail.properties" "mail.properties"
ln -fs "../../../../../../CONFIG-ENVIRONMENT/EXTRA-CODE/CODEs/HED_CODE/examples/base/java/mail.sender-0.0.1-jar-with-dependencies.jar" "mail.sender-0.0.1-jar-with-dependencies.jar"
cd "../../"

popd

# CODE - CEDN

mkdir -p $CODES_FOLDER_CONF"/"$CEDN_CODE_FOLDER_CONF"/data/"
pushd $PWD
cd $CODES_FOLDER_CONF"/"$CEDN_CODE_FOLDER_CONF"/data/"
ln -fs "../../../"$DATABASE_FOLDER_NAME_CONF"/"$PASCAL_CONTEXT_NAME_CONF"/" $PASCAL_CONTEXT_NAME_CONF
popd

pushd $PWD
mkdir -p $CODES_FOLDER_CONF"/"$CEDN_CODE_FOLDER_CONF"/code-cedn/"
cd $CODES_FOLDER_CONF"/"$CEDN_CODE_FOLDER_CONF"/code-cedn/"

mkdir -p "./base/conf"
cd "./base/conf"
ln -fs "../../../../../../CONFIG-ENVIRONMENT/EXTRA-CODE/CODEs/CEDN_CODE/code-cedn/base/conf/vgg-16-encoder-decoder-contour_solver.prototxt" "vgg-16-encoder-decoder-contour_solver.prototxt"
ln -fs "../../../../../../CONFIG-ENVIRONMENT/EXTRA-CODE/CODEs/CEDN_CODE/code-cedn/base/conf/vgg-16-encoder-decoder-contour-pascal-train-TEST.prototxt" "vgg-16-encoder-decoder-contour-pascal-train-TEST.prototxt"
ln -fs "../../../../../../CONFIG-ENVIRONMENT/EXTRA-CODE/CODEs/CEDN_CODE/code-cedn/base/conf/vgg-16-encoder-decoder-contour-pascal-train-WEIGTH_FIXED_INITIALIZATION_NO_TRAIN.prototxt" "vgg-16-encoder-decoder-contour-pascal-train-WEIGTH_FIXED_INITIALIZATION_NO_TRAIN.prototxt"
ln -fs "../../../../../../CONFIG-ENVIRONMENT/EXTRA-CODE/CODEs/CEDN_CODE/code-cedn/base/conf/vgg-16-encoder-decoder-contour-pascal-train-WEIGTH_FIXED_INITIALIZATION_TRAIN.prototxt.prototxt" "vgg-16-encoder-decoder-contour-pascal-train-WEIGTH_FIXED_INITIALIZATION_TRAIN.prototxt.prototxt"
ln -fs "../../../../../../CONFIG-ENVIRONMENT/EXTRA-CODE/CODEs/CEDN_CODE/code-cedn/base/conf/vgg-16-encoder-decoder-contour-pascal-train-WEIGTH_RANDOM_INITIALIZATION_TRAIN.prototxt" "vgg-16-encoder-decoder-contour-pascal-train-WEIGTH_RANDOM_INITIALIZATION_TRAIN.prototxt"
cd "../../"

mkdir -p "./base/matlab"
cd "./base/matlab"
ln -fs "../../../../../../CONFIG-ENVIRONMENT/EXTRA-CODE/CODEs/CEDN_CODE/code-cedn/base/matlab/train.m" "train.m"
ln -fs "../../../../../../CONFIG-ENVIRONMENT/EXTRA-CODE/CODEs/CEDN_CODE/code-cedn/base/matlab/matcaffe_fcn_vgg_init.m" "matcaffe_fcn_vgg_init.m"
ln -fs "../../../../../../CONFIG-ENVIRONMENT/EXTRA-CODE/CODEs/CEDN_CODE/code-cedn/base/matlab/color_convert.m" "color_convert.m"
ln -fs "../../../../../../CONFIG-ENVIRONMENT/EXTRA-CODE/CODEs/CEDN_CODE/code-cedn/base/matlab/colorspace.m" "colorspace.m"
cd "../../"

mkdir -p "./base/py"
cd "./base/py"
ln -fs "../../../../../../CONFIG-ENVIRONMENT/EXTRA-CODE/CODEs/CEDN_CODE/code-cedn/base/py/colorspace.py" "colorspace.py"
cd "../../"

mkdir -p "./base/sh"
cd "./base/sh"
ln -fs "../../../../../../CONFIG-ENVIRONMENT/EXTRA-CODE/CODEs/CEDN_CODE/code-cedn/base/sh/run.sh" "run.sh"
ln -fs "../../../../../../CONFIG-ENVIRONMENT/EXTRA-CODE/CODEs/CEDN_CODE/code-cedn/base/sh/cedn.sh" "cedn.sh"
ln -fs "../../../../../../CONFIG-ENVIRONMENT/EXTRA-CODE/CODEs/CEDN_CODE/code-cedn/base/sh/train.sh" "train.sh"
ln -fs "../../../../../../CONFIG-ENVIRONMENT/EXTRA-CODE/CODEs/CEDN_CODE/code-cedn/base/sh/send-mail.sh" "send-mail.sh"
cd "../../"

mkdir -p "./base/java"
cd "./base/java"
ln -fs "../../../../../../CONFIG-ENVIRONMENT/EXTRA-CODE/CODEs/CEDN_CODE/code-cedn/base/java/mail.properties" "mail.properties"
ln -fs "../../../../../../CONFIG-ENVIRONMENT/EXTRA-CODE/CODEs/CEDN_CODE/code-cedn/base/java/mail.sender-0.0.1-jar-with-dependencies.jar" "mail.sender-0.0.1-jar-with-dependencies.jar"
cd "../../"

popd

#####################################################################################
# Done
#####################################################################################

echo "Configuration done."

pushd $PWD
cd $CODES_FOLDER_CONF"/"$HED_CODE_FOLDER_CONF"/"
echo "Complie HED code: "$PWD
popd

pushd $PWD
cd $CODES_FOLDER_CONF"/"$CEDN_CODE_FOLDER_CONF"/"
echo "Complie CEDN code: "$PWD
popd
