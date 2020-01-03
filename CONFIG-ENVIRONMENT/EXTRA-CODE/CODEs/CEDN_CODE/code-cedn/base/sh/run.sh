#https://askubuntu.com/questions/420981/how-do-i-save-terminal-output-to-a-file
if [ $# -eq 0 ]; then
    bash ./cedn.sh |& tee cedn.log
else
    bash ./cedn.sh |& tee $1
fi
