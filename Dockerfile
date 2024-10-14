FROM ubuntu:23.04

ARG MUSE_VERSION=2.1.2
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    git g++ cmake autoconf libtool liblzma-dev zlib1g-dev libbz2-dev libcurl3-dev libssl-dev \
    ca-certificates cpp make libltdl-dev wget unzip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*


WORKDIR /src/
RUN wget https://github.com/wwylab/MuSE/archive/refs/tags/v${MUSE_VERSION}.zip \
    && unzip v${MUSE_VERSION}.zip && rm v${MUSE_VERSION}.zip

RUN cd /src/MuSE-${MUSE_VERSION} && bash ./install_muse.sh
RUN ln -s /src/MuSE-${MUSE_VERSION}/MuSE /usr/local/bin/

# Change the default user to bldocker from root
RUN groupadd -g 500001 bldocker && \
    useradd -r -u 500001 -g bldocker bldocker
USER bldocker

LABEL maintainer="Sorel Fitz-Gibbon <sfitzgibbon@mednet.ucla.edu>" \
        org.opencontainers.image.source=https://github.com/uclahs-cds/docker-MuSE
