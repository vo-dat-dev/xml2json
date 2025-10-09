FROM kong/kong-gateway:latest

USER root

RUN apt-get update
RUN apt-get update && \
    apt-get install -y nodejs && \
    apt-get install -y curl &&\
    apt-get install -y unzip && \
    rm -rf /var/lib/apt/lists/*

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y curl
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y nodejs
RUN npm config set registry https://registry.npmmirror.com/

RUN npm install -g kong-pdk

COPY kong-plugin/js/xml2json /usr/local/kong/js-plugins/

WORKDIR /usr/local/kong/js-plugins/
RUN npm install
WORKDIR /

RUN apt-get update && \
    apt-get install -y unzip && \
    rm -rf /var/lib/apt/lists/*

COPY xml2lua usr/local/share/lua/5.1/kong/plugins/xml2json
RUN luarocks install xml2lua
RUN luarocks install lua2json

COPY kong.conf /etc/kong/kong.conf

USER kong

EXPOSE 8000 8443 8001 8444
STOPSIGNAL SIGQUIT
HEALTHCHECK --interval=10s --timeout=10s --retries=10 CMD kong health
CMD ["kong", "docker-start"]
