FROM arm64v8/ubuntu

# docker build -t andresvidal/strapi-arm64v8 .
# docker run -it --rm -p 1337:1337 -v `pwd`/backend:/srv/app andresvidal/strapi-arm64v8

# docker run -it --rm -p 1337:1337 -v `pwd`/backend:/srv/app -v `pwd`/data:/data andresvidal/strapi-arm64v8

# Using https://git-lfs.github.com/

# compress precompiled
# sudo tar -cvf strapi-backend-arm64v8-precompiled.tar backend
# sudo brotli -6 strapi-backend-arm64v8-precompiled.tar -o strapi-backend-arm64v8-precompiled.tar.br
#
# decompress precompiled
# sudo brotli -d strapi-backend-arm64v8-precompiled.tar.br -o strapi-backend-arm64v8-precompiled.tar
# sudo tar -xvf strapi-backend-arm64v8-precompiled.tar

ENV TZ="America/New_York"
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y curl
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -

RUN apt-get install -y \
    python \
    libvips \
    libvips-tools \
    libvips-dev \
    nodejs \
    && rm -rf /var/lib/apt/lists/*

ARG STRAPI_VERSION
RUN npm i -g create-strapi-app strapi@${STRAPI_VERSION}

ENV DATABASE_FILENAME=/data/data.db
RUN mkdir /data && chown 1000:1000 -R /data
VOLUME /data

RUN mkdir /srv/app && chown 1000:1000 -R /srv/app
WORKDIR /srv/app
VOLUME /srv/app

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 1337
CMD ["strapi", "develop"]
