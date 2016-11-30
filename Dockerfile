FROM hypriot/rpi-node:6.9-slim

# grab tini for signal processing and zombie killing
ENV TINI_VERSION 0.13.0
RUN set -x \
    && wget -O /usr/local/bin/tini  "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-armhf" \
    && wget -O /usr/local/bin/tini.asc "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-armhf.asc"\
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys 6380DC428747F6C393FEACA59A84159D7001A4E5 \
    && gpg --batch --verify /usr/local/bin/tini.asc /usr/local/bin/tini \
    && rm -r "$GNUPGHOME" /usr/local/bin/tini.asc \
    && chmod +x /usr/local/bin/tini \
    && tini -h \
    && apt-get purge --auto-remove -y ca-certificates \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 8081

# override some config defaults with values that will work better for docker
ENV ME_CONFIG_EDITORTHEME="default" \
    ME_CONFIG_MONGODB_SERVER="mongo" \
    ME_CONFIG_MONGODB_ENABLE_ADMIN="true" \
    ME_CONFIG_BASICAUTH_USERNAME="" \
    ME_CONFIG_BASICAUTH_PASSWORD="" \
    VCAP_APP_HOST="0.0.0.0"

ENV MONGO_EXPRESS 0.32.0

RUN npm install mongo-express@$MONGO_EXPRESS

WORKDIR /node_modules/mongo-express

RUN cp config.default.js config.js

CMD ["tini", "--", "node", "app"]
