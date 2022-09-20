FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    git g++ cmake autoconf libtool liblzma-dev zlib1g-dev libbz2-dev libcurl3-dev libssl-dev \
    ca-certificates cpp make libltdl-dev wget unzip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*


ENV MUSE_SHA512=824417ee5f5e20073fc7504fa4d931e4f95c9df2cb6cc856808784f3519f4ef2bbe5b123e464f763f20b8a37443d27d1698f2170efc7efa78cd922a97775074a
WORKDIR /src/
RUN wget https://github.com/wwylab/MuSE/archive/refs/tags/v2.0.zip \
    && echo "${MUSE_SHA512} v2.0.zip" | sha512sum --strict -c \
    && unzip v2.0.zip \
    && mv MuSE-2.0 MuSE \
    && chmod 777 -R /src/MuSE

RUN cd /src/MuSE && bash ./install_muse.sh
ENV PATH="${PATH}:/src/MuSE"

# Change the default user to bldocker from root
RUN groupadd -g 500001 bldocker && \
    useradd -r -u 500001 -g bldocker bldocker
USER bldocker

LABEL maintainer="Mao Tian <maotian@mednet.ucla.edu>"
