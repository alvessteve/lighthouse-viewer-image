FROM node:23-alpine3.19 AS build
LABEL authors="stevealvesblyt"

ADD git@github.com:GoogleChrome/lighthouse.git .

RUN yarn install \
    && yarn build-report \
    && yarn build-cdt-lib \
    && yarn build-viewer

FROM caddy:2.8.4-alpine AS runtime

COPY --from=build /dist/gh-pages /dist/gh-pages
COPY Caddyfile /etc/caddy/Caddyfile

EXPOSE 7333

CMD ["caddy", "run" , "--config", "/etc/caddy/Caddyfile"]