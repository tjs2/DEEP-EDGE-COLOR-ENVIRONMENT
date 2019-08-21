#####################################################################################
# CONFIG
#####################################################################################

ENVIRONMENT_FOLDER_CONF="DEEP-EDGE-COLOR"

# DATABASEs

DATABASE_FOLDER_CONF="../"$ENVIRONMENT_FOLDER_CONF"/DATABASEs"

PASCAL_CONTEXT_URL_CONF="https://www.dropbox.com/s/m87yv50pj9vw774/pascal_context.zip?dl=0"
BSDS500_URL_CONF="https://www.dropbox.com/s/rhg0b43wp04am3h/bsds500.zip?dl=0"

PASCAL_CONTEXT_NAME_CONF="pascal_context"
BSDS500_NAME_CONF="bsds500"

# EVAL-CODE

EVAL_FOLDER_CONF="../"$ENVIRONMENT_FOLDER_CONF"/EVAL-CODE"

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

# CODEs

cp -rf "./EXTRA-CODE/CODEs/HED_CODE/examples/" $CODES_FOLDER_CONF"/"$HED_CODE_FOLDER_CONF"/"
# cp -rf "./EXTRA-CODE/CODEs/CEDN_CODE/" $CODES_FOLDER_CONF"/"$CEDN_CODE_FOLDER_CONF
