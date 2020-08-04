FROM openjdk:11-jdk
MAINTAINER Florin Duroiu <florin@metaflow.net>

RUN \
    echo "deb http://ftp.us.debian.org/debian/ jessie main contrib non-free \
    deb-src http://ftp.us.debian.org/debian/ jessie main contrib non-free" >> /etc/apt/sources.list && \
    apt update && \
        apt install -y build-essential cmake git gcc-4.8 g++-4.8 ant openexr libdc1394-22-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev \
    libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev liblzma-dev libjpeg-dev libjbig-dev

RUN \
    cd ~ && \
    git clone  https://github.com/opencv/opencv.git &&  \
    git clone https://github.com/opencv/opencv_contrib

RUN \
    cd ~/opencv_contrib; git checkout 4.4.0 && \
    cd ~/opencv; git checkout 4.4.0; mkdir build;cd build && \
    CC=/usr/bin/gcc-4.8 CXX=/usr/bin/g++-4.8 cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local \
        -DBUILD_opencv_java=ON ..

RUN  \
  cd ~/opencv/build; make -j $(nproc)

RUN   \
    cd ~/opencv/build; make install && \
    ldconfig && \
    rm -rf ~/opencv/build && \
    rm -rf ~/opencv/3rdparty && \
    rm -rf ~/opencv/doc && \
    rm -rf ~/opencv/include && \
    rm -rf ~/opencv/platforms && \
    rm -rf ~/opencv/modules && \
    rm -rf ~/opencv_contrib/build && \
    rm -rf ~/opencv_contrib/doc && \
    echo 'OpenCV 4 jar and .so are  available in /usr/local/share/java/opencv4/'

