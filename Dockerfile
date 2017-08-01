FROM ubuntu:16.04

MAINTAINER Julian Rachman <jmrachman@gmail.com>

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        git \
        libfreetype6-dev \
        libpng12-dev \
        libzmq3-dev \
        pkg-config \
        python3 \
        python3-dev \
        python3-tk \
        rsync \
        software-properties-common \
        unzip \
        vim \
        wget \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
    python3 get-pip.py && \
    rm get-pip.py

RUN pip --no-cache-dir install \
        GitPython \
        Pillow \
        beautifulsoup4 \
        elasticsearch \
        exceptions \
        h5py \
        ipykernel \
        jupyter \
        jupyter-cjk-xelatex \
        matplotlib \
        nbconvert \
        numpy \
        pandas \
        requests \
        scipy \
        scrapy \
        selenium \
        sklearn \
        zeep \
        && \
    python3 -m ipykernel.kernelspec
    

#=========
# Firefox
#=========
ARG FIREFOX_VERSION=54.0
RUN apt-get update -qqy \
  && apt-get -qqy --no-install-recommends install firefox \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/* \
  && wget --no-verbose -O /tmp/firefox.tar.bz2 https://download-installer.cdn.mozilla.net/pub/firefox/releases/$FIREFOX_VERSION/linux-x86_64/en-US/firefox-$FIREFOX_VERSION.tar.bz2 \
  && apt-get -y purge firefox \
  && rm -rf /opt/firefox \
  && tar -C /opt -xjf /tmp/firefox.tar.bz2 \
  && rm /tmp/firefox.tar.bz2 \
  && mv /opt/firefox /opt/firefox-$FIREFOX_VERSION \
&& ln -fs /opt/firefox-$FIREFOX_VERSION/firefox /usr/bin/firefox

#============
# geckodriver
#============
ARG GECKODRIVER_VERSION=0.17.0
RUN wget --no-verbose -O /tmp/geckodriver.tar.gz https://github.com/mozilla/geckodriver/releases/download/v$GECKODRIVER_VERSION/geckodriver-v$GECKODRIVER_VERSION-linux64.tar.gz \
  && rm -rf /opt/geckodriver \
  && tar -C /opt -zxf /tmp/geckodriver.tar.gz \
  && rm /tmp/geckodriver.tar.gz \
  && mv /opt/geckodriver /opt/geckodriver-$GECKODRIVER_VERSION \
  && chmod 755 /opt/geckodriver-$GECKODRIVER_VERSION \
&& ln -fs /opt/geckodriver-$GECKODRIVER_VERSION /usr/bin/geckodriver

# --- DO NOT EDIT OR DELETE BETWEEN THE LINES --- #
RUN pip install tensorflow==1.2.1
# --- ~ DO NOT EDIT OR DELETE BETWEEN THE LINES --- #

COPY jupyter_notebook_config.py /root/.jupyter/

COPY notebooks /notebooks

COPY run_jupyter.sh /notebooks/config

EXPOSE 6006

EXPOSE 8888

WORKDIR "/notebooks"

RUN cd config && chmod +x run_jupyter.sh
