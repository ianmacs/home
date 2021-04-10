Home
====

Home automation project template.

Combination of node-red, mosquitto, influxdb and grafana using docker-compose.

### How to use

Clone the project on your home automation server:

```
git clone git@github.com:ianmacs/Home`
cd Home
git remote rm origin
```

The node-red project created from this template will contain passwords
for mqtt, influxdb, grafana and possibly others either in plain text,
or encrypted with another passsword that is available in plain text.
Treat the whole home automation project generated from this template
as confidential.  Do not manage it in a public github repository or
similar.  Do not upload it to any cloud or rented server.

## Set up mqtt password

By default, user `home` with password `password` is configured for
mosquitto.  Change the user name and the password before developing a
home automation project from this template on the server.  Replace
USERNAME with the user name that you want to configure for mosquitto:

```
docker pull eclipse-mosquitto
docker run --rm -i eclipse-mosquitto mosquitto_passwd -c /proc/self/fd/2 USERNAME 2>mosquitto/config/passwordfile
git commit -m "Set MQTT user name and password" mosquitto/config/passwordfile
```

## Set up grafana

The grafana docker container uses a non-root user to execute the grafana
service.  It needs write access to the directory grafana/storage in
order to store the configuration:

```
chmod a+w grafana/storage/
```

## InfluxDB is used in version 1.8

The most recent version of InfluxDB is version 2.0.  This project uses
version 1.8 instead, because 2.0 only runs on 64 bit operating systems
and this project should be compatible to the standard Raspberry Pi OS
which runs in 32 bit mode.  Influxdb 1.8 still receives updates.

## Initialize the node-red project

You may want to configure a private upstream repository for your smart
home project with `git remote add origin <your-private-git-URL>`.
Again, because the repository contains passwords, I recommend against
pushing it to clouds or rented servers.

Start
```
docker-compose up -d
```
inside the git project on your home automation server.

Visit http://your-server:1880/.  You will see an error message:
![Project package file not found. The project is missing a
package.json file.](./docs/imgs/Project-package-file-not-found.png)
Click the "Setup project files" button.

This will open a project settings dialogue: ![Project settings
dialogue screenshot](./docs/imgs/Project-Settings.png) Click the small
"edit" button near the upper right corner of the dialogue, then click
"Save", then "Close".

You can now start using node-red through the browser as usual,
including commiting your changes to git as the projects feature is
enabled.

# Using mosquitto, influxdb, and grafana

From inside node-red, use host name "mosquitto" to reach the mosquitto
service with the user name and password configured previously.

The docker-compose project publishes mosquitto's ports 1883 and 9001
on the network interface of your home automation server, so that it
can be used by smart home devices inside your smart home network.

From inside node-red, use host name "influxdb" to reach the influxdb
service.  The influxdb service is not reachable from outside the
docker-compose setup.  The influxdb nodes need to be installed via
"Manage Palette" before node-red flows can use influxdb.

The docker-compose project publishes grafana's port 3000 on the
network interface of your home automation server, so that it can be
used to display the state and history of your home automation.
Default credentials are admin/admin, and you have to change the
password on first login through the browser.

### Backing up the state of your home automation server

To be tested: If you can afford server downtime during the backup, then
this procedure should work to create a full copy of the current state:
```
docker-compose stop
rsync -avz . remote-location
docker-compose up -d
```

where remote-location can be a backup directory on another server, e.g.
`user@host:/some/path` or a directory on the same server.

## Restore a backed-up state of your home automation server

To be tested:  A backup created as described above can be directly run with
```
docker-compose up -d
```
