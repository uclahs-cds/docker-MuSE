FROM ubuntu:20.04

ARG MUSE_VERSION=2.0.2
ARG MUSE_SHA512=6e69a00977a3f231017295135d0406fcdf33d2ef0e284f409dee44f715ca54f5c6f1e854bf60633c2d3b97cf4c57cedd51f10e68281b388c1c00ade13d6c9551
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    git g++ cmake autoconf libtool liblzma-dev zlib1g-dev libbz2-dev libcurl3-dev libssl-dev \
    ca-certificates cpp make libltdl-dev wget unzip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*


WORKDIR /src/
RUN wget https://github.com/wwylab/MuSE/archive/refs/tags/v${MUSE_VERSION}.zip \
    && echo "${MUSE_SHA512} v${MUSE_VERSION}.zip" | sha512sum --strict -c \
    && unzip v${MUSE_VERSION}.zip && rm v${MUSE_VERSION}.zip

RUN cd /src/MuSE-${MUSE_VERSION} && bash ./install_muse.sh
RUN ln -s /src/MuSE-${MUSE_VERSION}/MuSE /usr/local/bin/

# Change the default user to bldocker from root
RUN groupadd -g 500001 bldocker && \
    useradd -r -u 500001 -g bldocker bldocker
USER bldocker

LABEL maintainer="Mao Tian <maotian@mednet.ucla.edu>"
