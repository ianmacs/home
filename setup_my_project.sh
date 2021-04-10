#!/bin/bash -ex

# This script will detach this repository from its origin,
# set the username and password for MQTT in your project,
# set the database name for influxdb and delete itself.

# Change the following settings for your project:

# set the mosquitto username and password, separated by colon.
MQTT_USER_PASSWORD=home:password

# set the influxdb database name
INFLUXDB_DATABASE=home

# No more settings below this line.

cd $(dirname $0)

# Do not execute setup a second time
if test -f setup
then echo "setup has already been run. exiting."
     exit 1
fi

# Check if docker works before changing anything
docker pull eclipse-mosquitto

# Check if git works before starting for real
date >setup
git add setup
git commit -m 'setup' setup || exit 1

if true
then git remote origin
     echo "Git origin removed."
else echo "Not removing git origin."
fi

echo "Setting username and password for mosquitto"
echo "$MQTT_USER_PASSWORD" >mosquitto/config/passwordfile
docker run --rm -i -v$PWD/mosquitto/config/passwordfile:/passwordfile eclipse-mosquitto mosquitto_passwd -U /passwordfile



docker-compose up -d
