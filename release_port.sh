PORT=$1
# get process take port => in second line of output => get PID in second column
INFO_HEADER=`sudo lsof -nPi :$PORT | sed -n 1p`
PROCESS_INFO=`sudo lsof -nPi :$PORT | sed -n 2p`
PROCESS_NAME=`echo $PROCESS_INFO | awk '{print $1}'`
PID=`echo $PROCESS_INFO | awk '{print $2}'`

if [ -z "$PID" ]
then
    echo "Port $PORT already free"
else
    echo "Are you sure to release port from this process? [y/n]"
    echo
    echo $INFO_HEADER
    echo $PROCESS_INFO
    read ANS
    if [[ $ANS == "y" ]]
    then
        sudo kill -9 $PID
        echo "Release port $PORT success from process '$PROCESS_NAME'"
    fi
fi