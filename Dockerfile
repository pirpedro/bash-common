FROM alpine:3.15
LABEL MANTAINER="Pedro Rodrigues <pir.pedro@gmail.com>"

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

RUN apk add \
  bash \
  git \
  sudo \
  make \
  ncurses \
  zip \
  bats

RUN addgroup -g 1000 -S app && adduser -u 1000 -S app -G app -s /bin/bash \
  && adduser app wheel \
  && sed -e 's;^# \(%wheel.*NOPASSWD.*\);\1;g' -i /etc/sudoers \
  && mkdir -p /usr/src/app \
  && chown -R app:app /usr/src