FROM docker:latest@sha256:3a33fc81fa4d38360f490f5b900e9846f725db45bb1d9b1fe02d849bd42a5cf2

RUN apk add --no-cache curl

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]