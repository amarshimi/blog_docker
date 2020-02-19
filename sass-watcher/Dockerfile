FROM debian:stretch-slim

RUN apt-get update && apt-get install -y curl && apt-get install -y gnupg2

# Install Node.js v10.x, NPM and Sass. Then watch Sass files.
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g --unsafe-perm node-sass

CMD node-sass --watch --recursive /sass --output /css --source-map true