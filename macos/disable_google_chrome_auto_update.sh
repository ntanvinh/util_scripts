function help {
    echo "USAGE:"
    echo "this-script [-e]"
    echo
    echo "EXAMPLE:"
    echo "this-scrip"
    echo
    echo "OPTIONAL PARAMETERS:"
    echo "-e : enable Google Chrome update"
}

if [ $# -gt 1 ]
then
    echo "Error: script has maximum of 1 parameter."
    echo
    help
    exit
fi

# Enable Chrome autoupdate
if [[ $# == 0 ]]
then
    cd /Library/Google/
    sudo chown nobody:nogroup GoogleSoftwareUpdate
    sudo chmod 000 GoogleSoftwareUpdate
    cd ~/Library/Google/
    sudo chown nobody:nogroup GoogleSoftwareUpdate
    sudo chmod 000 GoogleSoftwareUpdate

    cd /Library/
    sudo chown nobody:nogroup Google
    sudo chmod 000 Google
    cd ~/Library/
    sudo chown nobody:nogroup Google
    sudo chmod 000 Google
    echo "Disable Chrome Auto-update Successfully!"
elif [[ $1 == "-e" ]]
then
    OWNER=`whoami`
    cd /Library/
    sudo chown "$OWNER":staff Google
    sudo chmod 755 Google
    cd ~/Library/
    sudo chown "$OWNER":staff Google
    sudo chmod 755 Google

    cd /Library/Google/
    sudo chown "$OWNER":staff GoogleSoftwareUpdate
    sudo chmod 755 GoogleSoftwareUpdate
    cd ~/Library/Google/
    sudo chown "$OWNER":staff GoogleSoftwareUpdate
    sudo chmod 755 GoogleSoftwareUpdate

    echo "Enable Chrome Auto-update Successfully!"
else
    echo "Error: wrong parameter"
    echo
    help
    exit
fi
