FROM alpine:latest as builder

RUN apk --update add openjdk7-jre

CMD ["/usr/bin/java", "-version"]

# Multistage builds to reduce size

#FROM alpine:latest as builder

MAINTAINER shivam patel

WORKDIR /tmp

# Install dependencies
RUN apk add --no-cache \
    build-base \
    ctags \
    git \
    libx11-dev \
    libxpm-dev \
    libxt-dev \
    make \
    ncurses-dev \
    python \
    python-dev

# Build vim from git source
RUN git clone https://github.com/vim/vim \
 && cd vim \
 && ./configure \
    --disable-gui \
    --disable-netbeans \
    --enable-multibyte \
    --enable-pythoninterp \
    --with-features=big \
    --with-python-config-dir=/usr/lib/python2.7/config \
 && make install

 FROM alpine:latest

 COPY --from=builder /usr/local/bin/ /usr/local/bin
 COPY --from=builder /usr/local/share/vim/ /usr/local/share/vim/

 RUN apk add --no-cache \
    diffutils \
    libice \
    libsm \
    libx11 \
    libxt \
    ncurses

ENTRYPOINT ["vim"]
