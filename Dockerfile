FROM docker:latest@sha256:6a58fe0da3d9c36bae9adb37ec6af8cb07b5a1d02aa72ae5ad370d7ecbafdfcd

RUN apk add --no-cache curl

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]