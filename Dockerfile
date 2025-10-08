# FROM kong/kong-gateway:latest

# # Ensure any patching steps are executed as root user
# USER root

# # Install unzip (Debian/Ubuntu base)
# RUN apt-get update && \
#     apt-get install -y unzip && \
#     rm -rf /var/lib/apt/lists/*
# # Add custom plugin to the image
# # COPY xml2lua usr/local/share/lua/5.1/kong/plugins/xml2lua
# # COPY kong-plugin-xml-json-transformer usr/local/share/lua/5.1/kong/plugins/kong-plugin-xml-json-transformer
# # ENV KONG_LUA_PACKAGE_PATH="/usr/local/share/lua/5.1/kong/plugins/xml2lua/?.lua;;"
# # RUN cp -r /usr/local/share/lua/5.1/kong/plugins/opentelemetry /usr/local/share/lua/5.1/kong/plugins/xml2lua
# # ENV KONG_PLUGINS=xml2lua


# # Add xml to json
# COPY xml2lua usr/local/share/lua/5.1/kong/plugins/xml2json
# RUN luarocks install xml2lua
# RUN luarocks install lua2json

# RUN apt-get update -y && \
#     apt-get install -y curl && \
#     curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
#     apt-get install -y nodejs

# RUN node -v && npm -v


# # Use kong plugins with js

# RUN npm install kong-pdk -g
# COPY my-plugin /usr/local/kong/js-plugins

# WORKDIR /usr/local/kong/js-plugins
# RUN npm install 

# WORKDIR /


# COPY kong.conf /etc/kong/kong.conf

# # COPY kong-plugin-xml-json-transformer/kong/plugins/xml-json-transformer/xml2lua usr/local/share/lua/5.1/kong/plugins/xml2json

# # Ensure kong user is selected for image execution

# RUN apt-get update && apt-get install -y pipx


# RUN pipx install kong-pdk

# COPY hello /usr/local/kong/python-plugins

# USER root

# EXPOSE 8000 8443 8001 8444
# STOPSIGNAL SIGQUIT
# HEALTHCHECK --interval=10s --timeout=10s --retries=10 CMD kong health
# CMD ["kong", "docker-start"]


FROM kong/kong-gateway:latest

# Ensure any patching steps are executed as root user
USER root

# Add custom plugin to the image
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
# RUN npm install -g xml2js
ADD myjwt.js /usr/local/kong/js-plugins/
ADD package.json /usr/local/kong/js-plugins/
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


# Ensure kong user is selected for image execution
USER kong

# Run kong
# ENTRYPOINT ["/docker-entrypoint.sh"]
EXPOSE 8000 8443 8001 8444
STOPSIGNAL SIGQUIT
HEALTHCHECK --interval=10s --timeout=10s --retries=10 CMD kong health
CMD ["kong", "docker-start"]
