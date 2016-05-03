# Build:
#   docker build -t rtmp .
#
# Run:
#   docker run --name=rtmp -d -p 1935:1935 rtmp


FROM ubuntu:xenial

ENV DEBIAN_FRONTEND noninteractive
ENV PATH=$PATH:/usr/local/nginx/sbin

EXPOSE 1935

RUN mkdir /src && mkdir /config && mkdir /logs

RUN apt-get update && apt-get upgrade -y && apt-get clean
RUN apt-get install -y build-essential wget ffmpeg libpcre3-dev zlib1g-dev libssl-dev

RUN cd /src && wget http://nginx.org/download/nginx-1.9.15.tar.gz && tar zxf nginx-1.9.15.tar.gz && rm nginx-1.9.15.tar.gz

RUN cd /src && wget https://github.com/sergey-dryabzhinsky/nginx-rtmp-module/archive/v1.1.7.10.tar.gz && tar zxf v1.1.7.10.tar.gz && rm v1.1.7.10.tar.gz

RUN cd /src/nginx-1.9.15 && ./configure --add-module=/src/nginx-rtmp-module-1.1.7.10 --conf-path=/config/nginx.conf --error-log-path=/logs/error.log --http-log-path=/logs/access.log
RUN cd /src/nginx-1.9.15 && make && make install

ADD nginx.conf /config/nginx.conf

CMD "nginx"
