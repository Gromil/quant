FROM python:3.9.0-alpine3.12

ENV PYTHONUNBUFFERED=1 COLUMNS=200 \
    TZ=Asia/Almaty

ADD ./src/requirements.txt /src/

RUN sed -i "s/dl-cdn.alpinelinux.org/mirror.neolabs.kz/g" \
    /etc/apk/repositories \
    && apk update \
    && apk --no-cache add bash postgresql-dev \
# Django translations
    gettext \
# Add build dependencies
    && apk --no-cache add --virtual .build-deps \
    tzdata gcc g++ musl-dev libffi-dev make \
# Set timezone
    && ln -fs /usr/share/zoneinfo/Asia/Almaty /etc/localtime \
    && echo "Asia/Almaty" > /etc/timezone \
# Upgrade pip
    && pip install --upgrade pip setuptools wheel \
# Add project dependencies
    && pip install \
    --no-cache-dir -Ur /src/requirements.txt \
# Remove build dependencies
    && apk del .build-deps

COPY ./src /src

WORKDIR /src

CMD ["./entrypoint.sh"]
