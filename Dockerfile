FROM nginx:1.9

COPY ./app /usr/share/nginx/html/

EXPOSE 80/tcp

VOLUME /var/www/frujo/app

