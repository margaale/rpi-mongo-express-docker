FROM hypriot/rpi-node:6-slim

# grab tini for signal processing and zombie killing
ENV TINI_VERSION v0.10.0
RUN set -x \
    && wget -O /usr/local/bin/tini "https://github.com/ind3x/rpi-tini/releases/download/$TINI_VERSION/tini" \
    && chmod +x /usr/local/bin/tini \
    && tini -h

EXPOSE 8081

# override some config defaults with values that will work better for docker
ENV ME_CONFIG_EDITORTHEME="default" \
    ME_CONFIG_MONGODB_SERVER="mongo" \
    ME_CONFIG_MONGODB_ENABLE_ADMIN="true" \
    ME_CONFIG_BASICAUTH_USERNAME="" \
    ME_CONFIG_BASICAUTH_PASSWORD="" \
    VCAP_APP_HOST="0.0.0.0"

ENV MONGO_EXPRESS 0.31.0

RUN npm install mongo-express@$MONGO_EXPRESS

WORKDIR /node_modules/mongo-express

RUN cp config.default.js config.js

CMD ["tini", "--", "node", "app"]
