FROM alpine:3.2
RUN apk add --update nginx && rm -rf /var/cache/apk/*

COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY public /usr/share/nginx/html

CMD ["nginx", "-g", "daemon off;"]
