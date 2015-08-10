#!/bin/sh

go build generate_cert.go

mkdir -p ${HOME}/.docker/boot2docker
cp generate_cert ${HOME}/.docker/

# TODO: https://github.com/docker/docker/issues/7418
# When I use DOCKER_CONFIG tls doesn't seem to work as documented
#cd ${HOME}/.docker/boot2docker
cd ${HOME}/.docker

./generate_cert --cert=ca.pem --key=cakey.pem --org="Boot2Docker CA Cert"
./generate_cert --host=boot2docker,192.168.59.103 --ca=ca.pem --ca-key=cakey.pem --cert=servercert.pem --key=serverkey.pem
./generate_cert --ca=ca.pem --ca-key=cakey.pem --cert=cert.pem --key=key.pem

#echo "to use the 'boot2docker' tls certificates, set:"
#echo "    export DOCKER_CONFIG=${HOME}/.docker/boot2docker"
