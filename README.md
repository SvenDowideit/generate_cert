# generate_cert

generate the tls certs needed for Docker TLS socket.

run:

- `./make.sh`

Which will generate the certificate files you need and put them into your `~/.docker` dir

Then copy the certs from `~/.docker/` to your boot2docker and start the server with them:

- `sudo docker -d --tlsverify --tlscacert=ca.pem --tlscert=servercert.pem --tlskey=serverkey.pem -H tcp://0.0.0.0:2376 -D`

then back on your OSX box, you can run:

- docker -H 192.168.59.103:2376 --tls version

## Building

There's a Makefile, which then uses the Dockerfile to generate Linux, OSX and Windows binaries
