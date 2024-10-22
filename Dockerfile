FROM node:23-alpine3.19 AS build
LABEL authors="stevealvesblyt"

ADD git@github.com:GoogleChrome/lighthouse.git .

RUN yarn install \
    && yarn build-report \
    && yarn build-cdt-lib \
    && yarn build-viewer

FROM node:20.18.0-bookworm-slim AS runtime

COPY --from=build /dist/gh-pages /dist/gh-pages

RUN apt-get update \
    && apt-get install -y python3

WORKDIR /dist/gh-pages

EXPOSE 7333

CMD ["python3", "-m", "http.server", "7333"]