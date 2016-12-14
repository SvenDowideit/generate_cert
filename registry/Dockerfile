FROM registry:2

ADD https://github.com/SvenDowideit/generate_cert/releases/download/0.3/generate_cert-0.3-linux-amd64 /usr/local/bin/generate_cert
RUN chmod 755 /usr/local/bin/generate_cert

COPY start.sh /usr/local/bin/

ENTRYPOINT 
CMD ["start.sh"]
