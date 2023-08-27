FROM --platform=linux/amd64 alpine:latest

RUN apk update && \
    apk add apache2 apache2-utils postgresql-client

RUN mkdir -p /var/www/localhost/htdocs

RUN echo "Hello World from Apache!" > /var/www/localhost/htdocs/index.html

RUN sed -i 's/Listen 80/Listen 80/' /etc/apache2/httpd.conf
RUN sed -i 's#^DocumentRoot ".*#DocumentRoot "/var/www/localhost/htdocs"#' /etc/apache2/httpd.conf
RUN echo "ServerName localhost" >> /etc/apache2/httpd.conf

EXPOSE 80

CMD ["httpd", "-D", "FOREGROUND"]