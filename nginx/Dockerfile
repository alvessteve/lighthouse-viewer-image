FROM node:23-alpine3.19 AS build
LABEL authors="stevealvesblyt" \
      maintainer="stevealvesblyt" \
      version="1.0" \
      description="Lighthouse Viewer Docker Image"

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

RUN apk add --no-cache git \
    && git clone https://github.com/GoogleChrome/lighthouse.git . \
    && chown -R appuser:appgroup /app \
    && rm -rf .git

USER appuser

RUN yarn install --frozen-lockfile --production=false

RUN yarn build-report \
    && yarn build-cdt-lib \
    && yarn build-viewer

FROM nginx:alpine AS runtime

RUN addgroup -S appgroup && adduser -S appuser -G appgroup \
    && apk add --no-cache curl

COPY --from=build /app/dist/gh-pages/viewer /usr/share/nginx/html/viewer
COPY nginx.conf /etc/nginx/nginx.conf

# Change ownership of the nginx directories
RUN chown -R appuser:appgroup /var/cache/nginx \
    && chown -R appuser:appgroup /var/log/nginx \
    && chown -R appuser:appgroup /etc/nginx/conf.d \
    && touch /var/run/nginx.pid \
    && chown -R appuser:appgroup /var/run/nginx.pid \
    && chmod 744 /var/run/nginx.pid

EXPOSE 7333

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:7333/viewer/ || exit 1

USER appuser

ENV NODE_OPTIONS="--max-old-space-size=512"
ENV NODE_ENV=production
ENV DEBUG=0

CMD ["nginx", "-g", "daemon off;"]