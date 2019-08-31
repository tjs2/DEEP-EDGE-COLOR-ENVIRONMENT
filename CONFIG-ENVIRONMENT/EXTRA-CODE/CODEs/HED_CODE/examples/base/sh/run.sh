#https://askubuntu.com/questions/420981/how-do-i-save-terminal-output-to-a-file
if [ $# -eq 0 ]; then
    bash ./hed.sh |& tee hed.log
else
    bash ./hed.sh |& tee $1
fi
