#!/bin/sh

if [[ ! -f "/certs/cert.pem" ]]; then
	mkdir -p /certs
	cd /certs/
	generate_cert --cert=ca.pem --key=cakey.pem
	hostlist="$(ip a | grep "inet " | sed 's/.*inet \(.*\)\/.*/\1/g' | tr "\n" ",")$(hostname)"
	generate_cert --host=${hostlist} --ca=ca.pem --ca-key=cakey.pem --cert=servercert.pem --key=serverkey.pem
fi

export REGISTRY_HTTP_TLS_CERTIFICATE=/certs/servercert.pem
export REGISTRY_HTTP_TLS_KEY=/certs/serverkey.pem

registry serve /etc/docker/registry/config.yml
