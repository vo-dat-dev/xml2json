FROM nickblah/lua:5.4.6-luarocks-ubuntu

RUN apt-get update -qq > /dev/null \
    && apt-get install -y --no-install-recommends \
       build-essential \
       git \
       zip \
       lua5.4 \
       lua5.4-dev \
    && apt-get install build-essential git zip -qq > /dev/null \
    && luarocks install dkjson > /dev/null \
    && luarocks install luacheck > /dev/null  \
    && luarocks install luacov > /dev/null  \
    && luarocks install luacov-coveralls > /dev/null  \
    && luarocks install busted > /dev/null

# CMD ["busted"]
CMD ["sh", "-c", "busted; tail -f /dev/null"]

