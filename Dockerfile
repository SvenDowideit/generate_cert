
FROM golang:1.3-cross

RUN apt-get install -yq ssh

ADD . /go/src/github.com/SvenDowideit/generate_cert
WORKDIR /go/src/github.com/SvenDowideit/generate_cert

# Download (but not install) dependencies
RUN go get -d -v ./...

CMD ["make", "all"]
