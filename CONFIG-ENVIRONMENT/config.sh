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
# git -C $CODES_FOLDER_CONF"/"$CEDN_CODE_FOLDER_CONF checkout -B $CEDN_CODE_GIT_BRANCH_CONF "origin/"$CEDN_CODE_GIT_BRANCH_CONF

#####################################################################################
# EXTEND
#####################################################################################

# DATABASEs

cp -rf "./EXTRA-CODE/DATABASEs/pascal_context/." $DATABASE_FOLDER_CONF"/"$PASCAL_CONTEXT_NAME_CONF"/"
cp -rf "./EXTRA-CODE/DATABASEs/bsds500/." $DATABASE_FOLDER_CONF"/"$BSDS500_NAME_CONF"/"

## EVAL-CODE

pushd $PWD
cd $EVAL_FOLDER_CONF"/"$PDOLLAR_EDGES_FOLDER_CONF"/private/"
cp -f *.mexa64 ../
cp -f *.mexw64 ../
popd

# CODEs

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
cd "../../"

popd
