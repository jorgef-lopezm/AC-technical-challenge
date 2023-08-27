FROM --platform=linux/amd64 alpine:latest

LABEL maintainer="jorgef.lopezm@gmail.com"

# Install required packages
RUN apk update && \
    apk add apache2 apache2-utils postgresql-client \
    maven \
    openjdk11-jre-headless \
    git \
    unzip \
    curl \
    bash

# Install code-server (web-based VS Code)
RUN curl -o /tmp/code-server.tar.gz -L https://github.com/cdr/code-server/releases/download/v3.12.0/code-server-3.12.0-linux-amd64.tar.gz
RUN tar -xzf /tmp/code-server.tar.gz -C /usr/local/
RUN ln -s /usr/local/code-server*/bin/code-server /usr/local/bin/code-server

# Set up Apache
RUN mkdir -p /var/www/localhost/htdocs
RUN echo "Hello World from Docker Apache!" > /var/www/localhost/htdocs/index.html
RUN sed -i 's/Listen 80/Listen 80/' /etc/apache2/httpd.conf
RUN sed -i 's#^DocumentRoot ".*#DocumentRoot "/var/www/localhost/htdocs"#' /etc/apache2/httpd.conf
RUN echo "ServerName localhost" >> /etc/apache2/httpd.conf

EXPOSE 80 8080

CMD ["httpd", "-D", "FOREGROUND"]