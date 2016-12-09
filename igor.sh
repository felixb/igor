#! /bin/bash

set -e

# set up default values
IGOR_DOCKER_IMAGE=busybox  # select docker image
IGOR_DOCKER_COMMAND=sh     # run this command inside the docker conainer
IGOR_DOCKER_PULL=0         # force pulling the image before starting the container (0/1)
IGOR_DOCKER_RM=1           # remove container on exit (0/1)
IGOR_DOCKER_TTY=1          # open an interactive tty (0/1)
IGOR_DOCKER_USER=$(id -u)  # run commands inside the container with this user
IGOR_DOCKER_GROUP=$(id -g) # run commands inside the container with this group
IGOR_DOCKER_ARGS=''        # default arguments to docker run
IGOR_MOUNT_PASSWD=0        # mount /etc/passwd inside the container (0/1)
IGOR_MOUNT_GROUP=0         # mount /etc/group inside the container (0/1)
IGOR_WORKDIR=${PWD}        # use this workdir inside the container
IGOR_WORKDIR_MODE=rw       # mount the workdir with this mode (ro/rw)
IGOR_ENV=''                # space separated list of environment variables set inside the container

if [ "${1}" == '-v' ]; then
    shift
    set -x
fi

if [ "${1}" == '--help' ]; then
    echo "$0 - opens a shell in your favorite docker container"
    echo ''
    echo 'configuration:'
    echo ''
    echo ' - ~/.igor.sh is evaluated if available'
    echo ' - ./.igor.sh is evaluated if available'
    echo ''
    echo 'default config:'
    echo ''
    grep '^IGOR_' $0
    echo ''
    exit 1
fi

# load config from home
if [ -e "${HOME}/.igor.sh" ]; then
    . "${HOME}/.igor.sh"
fi

# load config from current working dir
if [ -e '.igor.sh' ]; then
    . '.igor.sh'
fi

# assamble command line
if [ ${IGOR_DOCKER_PULL} -gt 0 ]; then
    docker pull "${IGOR_DOCKER_IMAGE}"
fi

args=''
if [ ${IGOR_DOCKER_RM} -gt 0 ]; then
    args="${args} --rm"
fi
if [ ${IGOR_DOCKER_TTY} -gt 0 ]; then
    args="${args} -ti"
fi
if [ ${IGOR_MOUNT_PASSWD} -gt 0 ]; then
    args="${args} -v /etc/passwd:/etc/passwd:ro"
fi
if [ ${IGOR_MOUNT_GROUP} -gt 0 ]; then
    args="${args} -v /etc/group:/etc/group:ro"
fi
for e in ${IGOR_ENV}; do
    args="${args} -e ${e}=${!e}"
done

# execute!
exec docker run \
    ${args} \
    -u "${IGOR_DOCKER_USER}:${IGOR_DOCKER_GROUP}" \
    -v "${PWD}:${IGOR_WORKDIR}:rw" \
    -w "${IGOR_WORKDIR}" \
    ${IGOR_DOCKER_ARGS} \
    "${IGOR_DOCKER_IMAGE}" \
    ${IGOR_DOCKER_COMMAND}