# igor

Opens a shell in your favorite docker container mounting your current workspace into the container.

## Install

Just download the `igor.sh` and store it in your `$PATH` like this:

```shell
sudo curl https://raw.githubusercontent.com/felixb/igor/master/igor.sh -o /usr/local/bin/igor
sudo chmod +x /usr/local/bin/igor
```

## Usage

Without any config, igor launches a shell inside a busybox container:

```shell
(master) flx@t460:~/dev/igor$ ls -l
total 12
-rwxr-xr-x 1 flx flx 2269 Dez  9 21:52 igor.sh
-rw-r--r-- 1 flx flx 1072 Dez  9 21:41 LICENSE
-rw-r--r-- 1 flx flx  555 Dez  9 21:51 README.md

(master) flx@t460:~/dev/igor$ igor
Unable to find image 'busybox:latest' locally
latest: Pulling from library/busybox
56bec22e3559: Pull complete
Digest: sha256:29f5d56d12684887bdfa50dcd29fc31eea4aaf4ad3bec43daf19026a7ce69912
Status: Downloaded newer image for busybox:latest

/home/flx/dev/igor $ id
uid=1000 gid=1000

/home/flx/dev/igor $ ls -l
total 12
-rw-r--r--    1 1000     1000          1072 Dec  9 20:41 LICENSE
-rw-r--r--    1 1000     1000           555 Dec  9 20:51 README.md
-rwxr-xr-x    1 1000     1000          2269 Dec  9 20:52 igor.sh
```

Igor sources config from `~/.igor.sh` and `./.igor.sh` if available.

The following options are available as of writing this:

```shell
IGOR_DOCKER_IMAGE=busybox  # select docker image
IGOR_DOCKER_COMMAND=sh     # run this command inside the docker conainer
IGOR_DOCKER_PULL=0         # force pulling the image before starting the container (0/1)
IGOR_DOCKER_RM=1           # remove container on exit (0/1)
IGOR_DOCKER_TTY=1          # open an interactive tty (0/1)
IGOR_DOCKER_USER=$(id -u)  # run commands inside the container with this user
IGOR_DOCKER_GROUP=$(id -g) # run commands inside the container with this group
IGOR_DOCKER_ARGS=''        # default arguments to docker run
IGOR_PORTS=''              # space separated list of ports to expose
IGOR_MOUNT_PASSWD=0        # mount /etc/passwd inside the container (0/1)
IGOR_MOUNT_GROUP=0         # mount /etc/group inside the container (0/1)
IGOR_MOUNTS_RO=''          # space seperated list of volumes to mount read only
IGOR_MOUNTS_RW=''          # space seperated list of volumes to mount read write
IGOR_WORKDIR=${PWD}        # use this workdir inside the container
IGOR_WORKDIR_MODE=rw       # mount the workdir with this mode (ro/rw)
IGOR_ENV=''                # space separated list of environment variables set inside the container
```

To see all available options launch:

```shell
igor --help
```

## Specify an igor config

Run igor with `-c path-to-igor-config` to start a specific container.
Checkout the [example configs](example) in this repo.

## Contributing

Almost anything is welcome.
Just fork the repo and send a pull request.
