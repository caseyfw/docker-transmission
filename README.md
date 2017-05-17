# caseyfw/transmission

Dockerised [Transmission](https://en.wikipedia.org/wiki/Transmission_(BitTorrent_client)) BitTorrent client.

## Usage
The simplest use case is to volume a local directory to the `/downloads` directory of the container, and publish the web UI (9091) and BitTorrent ports (6881):

```
docker run --detach --volume /your/download/dir:/data \
    --publish 9091:9091 --publish 6881:6881 caseyfw/transmission
```

Transmission's web UI will now be available at http://localhost:9091 with the account `username` / `password`. Downloaded torrents will appear in `/your/download/dir`.

## Environment variables
Setting the following environment variables with the docker `--env` argument will change their corresponding setting in Transmission:

- `ALLOWED` comma separated whitelist of IP addresses allowed to access the web UI. Default: `*` (all IPs).
- `DOWNLOAD_DIR` the directory in the container to put downloaded files. Default: `/downloads`. You probably don't want to change this, just volume a directory from your host machine to `/downloads` in the container.
- `INCOMPLETE_DIR` the directory in the container to put incomplete downloads. Default: `/downloads/incomplete`.
- `PORT` the BitTorrent port. Default: `6881`. You probably don't want to change this, just map the port of your choosing to 6881 on the container using the `--publish` argument.
- `WEB_PORT` the web UI port. Default: `9091`. You probably don't want to change this, just map the port of your choosing to 9091 on the container using the `--publish` argument.
- `USERNAME` the web UI username. Default: `username`.
- `PASSWORD` the web UI username. Default: `password`.
- `UID` the user id to run Transmission as. Default: `0` (root). This is useful for ensuring downloads from Transmission are owned by the correct user. You probably want to set this to to `$(uid -u)` which is likely `1000`. See the example below.

## Example RaspberryPi usage
This container is useful for running Transmission on a RaspberryPi. Here is a suggested command to start Transmission if you have already installed Docker:

```
docker run --detach \
    --name transmission
    --restart=always \
    --volume /home/pi/Downloads:/data \
    --publish 8080:9091 \
    --publish 6881:6881 \
    --env "UID=$(id -u)" \
    --env "USERNAME=admin" \
    --env "PASSWORD=mysecretpassword" \
    caseyfw/transmission
```

Once run, Transmission's web UI will be available at http://localhost:8080 with the account `admin` / `mysecretpassword`. Downloads will appear in `~/Downloads` and should have the correct permissions. Note the `--restart=always` will cause Docker to bring the container back up if it dies or the Pi is restarted.
