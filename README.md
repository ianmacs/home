home
====

home automation project template

Combination of node-red, mosquitto, influxdb and grafana using docker-compose.

### How to use

Clone the project on your home automation server:

```
git clone git@github.com:ianmacs/home`
cd home
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
docker-compose setup.

The docker-compose project publishes grafana's port 3000 on the
network interface of your home automation server, so that it can be
used to display the state and history of your home automation.
Default credentials are admin/admin, and you have to change the
password on first login through the browser.

### Backing up the state of your home automation server

To be documented.

## Restore a backed-up state of your home automation server

To be documented.
