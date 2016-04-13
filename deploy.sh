#! /bin/sh

cd public
rsync -avz -e "ssh" --progress . thrawn01.org:/usr/share/nginx/thrawn01.org
