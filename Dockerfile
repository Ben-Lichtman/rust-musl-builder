# Build container
FROM alpine

# Install rust
ARG TOOLCHAIN=nightly
RUN echo "Installing rust" && \
apk add --update build-base curl git && \
curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain $TOOLCHAIN -y
ENV PATH /root/.cargo/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Install dependencies
WORKDIR /home/deps
RUN apk add --update perl && \
git clone git://git.openssl.org/openssl.git
WORKDIR /home/deps/openssl
ARG OPENSSL_VERSION=OpenSSL_1_0_2u
RUN echo "Building openssl" && \
git checkout tags/$OPENSSL_VERSION && \
./Configure no-shared no-zlib -fPIC linux-x86_64 && \
make && \
make install

# Setup evironment
WORKDIR /home/build
ENV RUSTFLAGS -C target-feature=-crt-static -C target-feature=+crt-static
ENV OPENSSL_DIR /usr/local/ssl
