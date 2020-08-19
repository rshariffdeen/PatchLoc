FROM ubuntu:18.04
MAINTAINER Ridwan <rshariffdeen@gmail.com>
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get upgrade -y && apt-get autoremove -y
RUN apt install -y \
 build-essential \
 doxygen \
 ipython \
 g++-multilib \
 ghostscript \
 git \
 imagemagick \
 libssl-dev \
 python-dev \
 python-pip \
 transfig \
 unzip \
 vim \
 wget \
 zlib1g-dev

# install numpy
RUN wget https://github.com/numpy/numpy/releases/download/v1.16.6/numpy-1.16.6.zip \
    && unzip numpy-1.16.6.zip \
    && cd ./numpy-1.16.6 \
    && python setup.py install \
    && cd ..

# install pyelftools
RUN pip install pyelftools

# install CMake
RUN wget https://github.com/Kitware/CMake/releases/download/v3.16.2/cmake-3.16.2.tar.gz  \
    && tar -xvzf ./cmake-3.16.2.tar.gz  \
    && cd ./cmake-3.16.2  \
    && ./bootstrap  \
    && make  -j32 \
    && make install  \
    && cd ..

# install Dynamorio
RUN git clone https://github.com/DynamoRIO/dynamorio.git  \
    && cd ./dynamorio \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make - j32 \
    && cd ../../

# Install the Dynamorio-based tracer
# iftracer.zip can be found in the folder "./code"
RUN unzip iftracer.zip  \
    && cd ./iftracer/iftracer  \
    && cmake CMakeLists.txt  \
    && make  -j32 \
    && cd ../ifLineTracer   \
    && cmake CMakeLists.txt  \
    && make -j32 \
    && cd ../../
