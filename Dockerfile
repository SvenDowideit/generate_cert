
FROM golang:1.7

ADD . /go/src/github.com/SvenDowideit/generate_cert
WORKDIR /go/src/github.com/SvenDowideit/generate_cert

# Download (but not install) dependencies
RUN go get -d -v ./...

CMD ["make", "all"]
