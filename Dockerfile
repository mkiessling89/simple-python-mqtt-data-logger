# syntax=docker/dockerfile:1

ARG PYTHON_VERSION=3.11.4

# FROM scratch
FROM python:${PYTHON_VERSION}-slim as base

# Prevents Python from writing pyc files.
ENV PYTHONDONTWRITEBYTECODE=1

# Keeps Python from buffering stdout and stderr to avoid situations where
# the application crashes without emitting any logs due to buffering.
ENV PYTHONUNBUFFERED=1

# WORKDIR /mqtt_simple/simple-python-mqtt-data-logger

RUN apt-get update \ 
 && apt-get -y dist-upgrade \
 && apt-get -y install \
    git \
    python3 \
    python3-venv \
    virtualenv \
    python3-virtualenv \
&& rm -rf /var/lib/apt/lists/*

WORKDIR /
RUN mkdir -p mqtt_simple
WORKDIR ./mqtt_simple
RUN git clone https://github.com/mkiessling89/simple-python-mqtt-data-logger.git
WORKDIR ./simple-python-mqtt-data-logger

RUN pip install --upgrade pip
RUN pip install -r requirements.txt

VOLUME /mqtt_data

EXPOSE 1883
# create env vars for all the arguments!
CMD python mqtt-data-logger.py -b raspberrypi-4 -t tele/tasmota_C78F39/# -l /mqtt_data
#CMD python mqtt-data-logger.py -b 192.168.0.125 -t tele/tasmota_C78F39/# -l /mqtt_data
