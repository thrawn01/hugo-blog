FROM nginx:1.11.12

COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY public /usr/share/nginx/html

CMD ["nginx", "-g", "daemon off;"]
