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

echo 'Send email parameters:'

echo ' . Subject:' $1
echo ' . Body:' $2
echo ' . Content:' $3 #text/html

MAIL_SUBJECT=$1
MAIL_BODY=$2
MAIL_CONTENT=$3
MAIL_CONTENT=${MAIL_CONTENT:=text/html}

##################################################################
# Execution
##################################################################

CMD="java -cp ../java/:../java/mail.sender-0.0.1-jar-with-dependencies.jar mail.sender.SMTPSender '$MAIL_SUBJECT' '$MAIL_BODY' '$MAIL_CONTENT'"

echo -e "\n"$CMD"\n"

if [ "$ONLY_PRINT_COMMANDS" = false ] ; then
    eval $CMD
fi
