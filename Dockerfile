ARG NODE_VERSION=20.10.0
ARG OPENCV_VERSION=4.8.0

ARG FUNCTION_DIR="/function"

FROM node:${NODE_VERSION}-bookworm-slim as build


RUN apt-get update && apt-get install -y \
    git \
    cmake \
    unzip \
    build-essential \
    pkg-config \
    make \
    python3

# Include global arg in this stage of the build
ARG OPENCV_VERSION
ARG FUNCTION_DIR

RUN mkdir -p ${FUNCTION_DIR}
COPY package.json ${FUNCTION_DIR}

RUN mkdir -p /opencv
ENV OPENCV_BUILD_ROOT=/opencv

WORKDIR ${FUNCTION_DIR}
RUN npm install --cpu=arm64 --os=linux
RUN npx build-opencv --version ${OPENCV_VERSION} --git-cache rebuild

# cleanup
RUN rm -rf /opencv/opencvGit && rm -rf /opencv/opencv_contribGit && \
    rm -rf /opencv/latest/build/3rdparty && rm -rf /opencv/latest/build/CMake* && \
    rm -rf /opencv/latest/build/CPack* && rm -rf /opencv/latest/build/CTest* && \
    rm -rf /opencv/latest/build/OpenCV* && rm -rf /opencv/latest/build/carotene && \
    rm -rf /opencv/latest/build/Makefile && rm -rf /opencv/latest/build/cmake* && \
    rm -rf /opencv/latest/build/custom_hal.hpp && rm -rf /opencv/latest/build/cv* && \
    rm -rf /opencv/latest/build/data && rm -rf /opencv/latest/build/doc && \
    rm -rf /opencv/latest/build/downloads && rm -rf /opencv/latest/build/include && \
    rm -rf /opencv/latest/build/install_manifest.txt && rm -rf /opencv/latest/build/bin && \
    rm -rf /opencv/latest/build/modules && rm -rf /opencv/latest/build/opencv* && \
    rm -rf /opencv/latest/build/setup_vars.sh && rm -rf /opencv/latest/build/text_config.hpp && \
    rm -rf /opencv/latest/build/tmp && rm -rf /opencv/latest/build/unix-install && \
    rm -rf /opencv/latest/build/version_string.tmp && rm -rf /opencv/latest/build-cmd.sh

FROM node:${NODE_VERSION}-bookworm-slim

# Include global arg in this stage of the build
ARG FUNCTION_DIR
RUN mkdir -p ${FUNCTION_DIR}
RUN mkdir -p /opencv
WORKDIR ${FUNCTION_DIR}
COPY --from=build ${FUNCTION_DIR} ${FUNCTION_DIR}
COPY --from=build /opencv /opencv






