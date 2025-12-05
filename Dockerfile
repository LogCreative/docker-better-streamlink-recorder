FROM python:3.12.2
MAINTAINER Jared Paquet <jaredpaquet@gmail.com>
ENV streamlinkCommit=5a83a3806b5941639c3751ac15a9fed175019b31
RUN apt-get update && apt-get install gosu python3-pip jq inotify-tools ffmpeg exiftool -y
RUN pip3 install --upgrade git+https://github.com/streamlink/streamlink.git@${streamlinkCommit}
RUN mkdir -p /storage
RUN mkdir -p /etc/streamlink/{encode,download,tools}

COPY ./download.sh /etc/streamlink/tools/
COPY ./encode.sh /etc/streamlink/tools/
COPY ./supervisord.conf /etc/supervisord.conf

RUN supervisord -n