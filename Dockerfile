FROM ind3x/rpi-alpine-node:6.9.1

# grab tini for signal processing and zombie killing
RUN echo "@community http://dl-cdn.alpinelinux.org/alpine/v3.4/community" >> /etc/apk/repositories \
    && apk add --update --no-cache tini@community


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
