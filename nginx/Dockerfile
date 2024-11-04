FROM node:23-alpine3.19 AS build
LABEL authors="stevealvesblyt"

ADD git@github.com:GoogleChrome/lighthouse.git .

RUN yarn install \
    && yarn build-report \
    && yarn build-cdt-lib \
    && yarn build-viewer

FROM nginx:1.27.2-bookworm AS runtime

COPY --from=build /dist/gh-pages /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 7333

CMD ["nginx", "-g", "daemon off;"]