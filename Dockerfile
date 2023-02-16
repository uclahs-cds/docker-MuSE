FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    git g++ cmake autoconf libtool liblzma-dev zlib1g-dev libbz2-dev libcurl3-dev libssl-dev \
    ca-certificates cpp make libltdl-dev wget unzip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*


ENV MUSE_SHA512=dd683bdd22c38aba422800ca48eaf74b18b22fab326568c925c692d625c546576aa3510dcccc8c7784884bf7de2ae8ce22dd2a672da6ff41791e0914fd93a4cb
WORKDIR /src/
RUN wget https://github.com/wwylab/MuSE/archive/refs/tags/v2.0.1.zip \
    && echo "${MUSE_SHA512} v2.0.1.zip" | sha512sum --strict -c \
    && unzip v2.0.1.zip && rm v2.0.1.zip

RUN cd /src/MuSE-2.0.1 && bash ./install_muse.sh
RUN ln -s /src/MuSE-2.0.1/MuSE /usr/local/bin/

# Change the default user to bldocker from root
RUN groupadd -g 500001 bldocker && \
    useradd -r -u 500001 -g bldocker bldocker
USER bldocker

LABEL maintainer="Mao Tian <maotian@mednet.ucla.edu>"
