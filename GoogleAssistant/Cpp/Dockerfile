FROM debian:buster


ENV GRPC_SOURCE     https://github.com/grpc/grpc
ENV GRPC_GIT_TAG    v1.41.1
ENV GOOAPIS_SOURCE  https://github.com/googleapis/googleapis.git
ENV GOOAPIS_TAG     980cdfa
ENV GPROJ_ROOT      /usr/src/googleapis

RUN apt-get update

RUN apt-get install -y \
            autoconf \
            file \
            automake \
            libtool \
            build-essential \
            curl \
            unzip \
            pkg-config \
            libasound2-dev \
            protobuf-compiler \
            libcurl4-openssl-dev \
            git \
            cmake

RUN mkdir ${GPROJ_ROOT} && \
    cd ${GPROJ_ROOT} && \
    git clone  -b ${GRPC_GIT_TAG} ${GRPC_SOURCE} && \ 
    cd grpc && git submodule update --init && \
    cd third_party/protobuf && \
    ./autogen.sh && ./configure && make &&\
    make install && \
    ldconfig

RUN cd ${GPROJ_ROOT}/grpc && \
    export LDFLAGS="$LDFLAGS -lm"  && \
    cmake -DgRPC_INSTALL=ON -DgRPC_BUILD_TESTS=OFF && \
    make -j && \
    make install && \
    ldconfig

RUN cd ${GPROJ_ROOT} && \
    git clone ${GOOAPIS_SOURCE} && \
    cd googleapis/ && \
    git checkout ${GOOAPIS_TAG} && \
    make LANGUAGE=cpp
    
RUN export GOOGLEAPIS_GENS_PATH=${GPROJ_ROOT}/googleapis/gens

RUN cd ${GPROJ_ROOT}/ && \
    git clone https://github.com/googlesamples/assistant-sdk-cpp.git && \
    cd assistant-sdk-cpp && \
    make run_assistant

ENTRYPOINT ["/bin/bash"]
CMD [""]





