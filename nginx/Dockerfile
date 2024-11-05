FROM node:23-alpine3.19 AS build
LABEL authors="stevealvesblyt"

ADD git@github.com:GoogleChrome/lighthouse.git .

RUN yarn install \
    && yarn build-report \
    && yarn build-cdt-lib \
    && yarn build-viewer

FROM nginx:alpine AS runtime

COPY --from=build /dist/gh-pages /dist/gh-pages
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 7333

CMD ["nginx", "-g", "daemon off;"]