FROM debian:stretch-slim

RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates apt-transport-https gpg curl

RUN echo "deb https://deb.torproject.org/torproject.org stretch main" >> /etc/apt/sources.list && \
echo "deb-src https://deb.torproject.org/torproject.org stretch main" >> /etc/apt/sources.list

RUN curl https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg --import
RUN gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add -

RUN apt-get update && apt install -y tor deb.torproject.org-keyring

# Create an unprivileged tor user
RUN addgroup -g 19001 -S tord && adduser -u 19001 -G tord -S tord

# Copy Tor configuration file
COPY ./torrc /etc/tor/torrc

# Persist data
VOLUME /var/lib/tor

# SocksPort
EXPOSE 9100

ENTRYPOINT ["docker-entrypoint"]
CMD ["tor", "-f", "/etc/tor/torrc"]
