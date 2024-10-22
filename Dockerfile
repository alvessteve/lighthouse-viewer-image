FROM node:23-alpine3.19
LABEL authors="stevealvesblyt"

ADD git@github.com:GoogleChrome/lighthouse.git .

RUN yarn install \
    && yarn build-report \
    && yarn build-cdt-lib \
    && yarn build-viewer

EXPOSE 7333

ENTRYPOINT ["yarn", "serve-viewer"]