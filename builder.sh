#!/bin/bash
#
#
# use a container to build a nonpareil rpm
#
############################################
#
# Parameter section
# 
## where to store the result
ARTIFACTS=/tmp/artifacts
#
## the container program
#DOCKER=docker
DOCKER=podman
#
## debugmode will NOT terminate the container but gives you a final shell
#DBG="--env DBGMODE=on"

#
############################################
#
# no need to change anything below
#
BUILDCONTAINER=nonpareil_build
RUNCONTAINER=nonpareil_run

if [ -f /var/run/.toolboxenv ]
then
	if [ -x /usr/sbin/distrobox-host-exec ]
	then
		prefix="distrobox-host-exec"
	else
		echo "$0: I think you are running inside a toolbox."
		echo "$0: I don't know access ${DOCKER} from there."
		exit 255
	fi
else
	prefix=""
fi
if [ ! -d ${ARTIFACTS} ]
then
	mkdir -p ${ARTIFACTS}
fi
export CONTAINERS_CONF=$(pwd)/containers.conf
$prefix ${DOCKER} image rm $BUILDCONTAINER
$prefix ${DOCKER} build -v ${HOME}/tmp/app:/app --tag ${BUILDCONTAINER} . && \
$prefix ${DOCKER} run -it ${DBG} --privileged -v ${ARTIFACTS}:/app  --name ${RUNCONTAINER} --rm ${BUILDCONTAINER}
echo "${0}: **********************************************************"
echo "${0}: ***"
echo "${0}: *** Done. Results are available in ${ARTIFACTS}"
echo "${0}: ***"
echo "${0}: **********************************************************"
