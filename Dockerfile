FROM debian:stable-slim

COPY run.sh /run.sh

RUN apt update \
 && apt install -y git python3 python3-dev python3-pip python3-setuptools python3-pkg-resources python3-hidapi python3.11-venv python3-usb i2c-tools python3-smbus libusb-1.0-0 gcc make udev libudev-dev --no-install-recommends

ENV VIRTUAL_ENV=/opt/venv

RUN python3 -m venv $VIRTUAL_ENV

ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN python3 -m pip install -U wheel cython \
 && python3 -m pip install git+https://github.com/liquidctl/liquidctl#egg=liquidctl \
 && apt remove --purge -y make gcc python3-dev libudev-dev python3-pip \
 && apt autoremove -y \
 && chmod 0700 /run.sh \
 && rm -rf /var/lib/apt/lists/*

CMD ["/run.sh"]
