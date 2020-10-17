#!/bin/bash

cd $(dirname $0)

date >setup
git add setup
git commit -m 'setup' setup || exit 1

function confirm ()
{
    read C
    echo -- "$C" | grep -qi '^y'
}

function confirm_final()
{
    if confirm
    then return
    else exit 1
    fi
}

echo "To start a home automation project from this repository, you should remove"
echo "the original git origin repository to avoid accidental pushes."
echo -n "Remove git origin? (y/n) "
if confirm
then git remote origin
     echo "Origin removed."
else echo "Not removing origin."
fi

docker pull eclipse-mosquitto
echo
echo "Set username and password for mosquitto"
echo -n "Enter user name:"
read MQTT_USER
echo Setting password for user "$MQTT_USER"
docker run --rm -i eclipse-mosquitto mosquitto_passwd -c /proc/self/fd/2 "$MQTT_USER" 2>mosquitto/config/passwordfile
git commit -m "Set MQTT user name and password" mosquitto/config/passwordfile

docker-compose up -d
