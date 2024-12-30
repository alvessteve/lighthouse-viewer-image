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

FROM caddy:2.8.4-builder-alpine AS caddy-builder

RUN xcaddy build \
    --with github.com/mholt/caddy-ratelimit

FROM alpine:3.19 AS runtime

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# mailcap is required for caddy to function
# see https://github.com/caddyserver/caddy/issues/4446
RUN apk add --no-cache ca-certificates mailcap

COPY --from=caddy-builder /usr/bin/caddy /usr/bin/caddy

WORKDIR /srv

# Create viewer directory and copy files
RUN mkdir -p /srv/viewer
COPY --from=build --chown=appuser:appgroup /app/dist/gh-pages/viewer/ /srv/viewer/
COPY --chown=appuser:appgroup Caddyfile /etc/caddy/Caddyfile

EXPOSE 7333

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD wget --spider -q http://localhost:7333/viewer/ || exit 1

USER appuser

ENV NODE_OPTIONS="--max-old-space-size=512"
ENV NODE_ENV=production
ENV DEBUG=0

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]