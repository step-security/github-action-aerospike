FROM docker:latest@sha256:1ba18449911d01f477a3fc104123c85d677addc60701b14b3fcb5381f9c4a537

RUN apk add --no-cache curl && apk upgrade --no-cache zlib openssl libexpat

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]