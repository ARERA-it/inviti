#! /bin/sh

git pull
docker-compose -f docker-compose.production.new.yml build
docker-compose -f docker-compose.production.new.yml down
docker-compose -f docker-compose.production.new.yml up -d
