FROM kong/kong-gateway:latest

# Ensure any patching steps are executed as root user
USER root

# Install unzip (Debian/Ubuntu base)
RUN apt-get update && \
    apt-get install -y unzip && \
    rm -rf /var/lib/apt/lists/*
# Add custom plugin to the image
# COPY xml2lua usr/local/share/lua/5.1/kong/plugins/xml2lua
# COPY kong-plugin-xml-json-transformer usr/local/share/lua/5.1/kong/plugins/kong-plugin-xml-json-transformer
# ENV KONG_LUA_PACKAGE_PATH="/usr/local/share/lua/5.1/kong/plugins/xml2lua/?.lua;;"
# RUN cp -r /usr/local/share/lua/5.1/kong/plugins/opentelemetry /usr/local/share/lua/5.1/kong/plugins/xml2lua
# ENV KONG_PLUGINS=xml2lua


# COPY kong-plugin/kong/plugins/myplugin usr/local/share/lua/5.1/kong/plugins/xml2json

COPY xml2lua usr/local/share/lua/5.1/kong/plugins/xml2json
RUN luarocks install xml2lua
RUN luarocks install lua2json

RUN apt-get update -y && \
    apt-get install -y curl && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

RUN node -v && npm -v

RUN npm install kong-pdk -g

# COPY kong-js-pdk/examples /usr/local/kong/js-plugins

COPY my-plugin /usr/local/kong/js-plugins/my-plugin

WORKDIR /usr/local/kong/js-plugins/my-plugin

RUN npm install 

WORKDIR /

# RUN cp /etc/kong/kong.conf.default /etc/kong/kong.conf

COPY kong.conf /etc/kong/kong.conf

# COPY kong-plugin-xml-json-transformer/kong/plugins/xml-json-transformer/xml2lua usr/local/share/lua/5.1/kong/plugins/xml2json

# Ensure kong user is selected for image execution
USER root

EXPOSE 8000 8443 8001 8444
STOPSIGNAL SIGQUIT
HEALTHCHECK --interval=10s --timeout=10s --retries=10 CMD kong health
CMD ["kong", "docker-start"]
