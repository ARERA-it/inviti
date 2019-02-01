FROM ruby:2.5.3-alpine
MAINTAINER Iwan Buetti <iwan.buetti@gmail.com>

RUN apk --update add --virtual build-dependencies \
                               build-base \
                               libxml2-dev \
                               libxslt-dev \
                               linux-headers \
                               postgresql-dev \
                               nodejs \
                               tzdata \
                               git \
                               yarn \
                               && rm -rf /var/cache/apk/*


ENV app /app
RUN mkdir $app
WORKDIR $app

ENV RAILS_ENV='production'
ENV RACK_ENV='production'

ENV BUNDLE_PATH /gems

COPY . $app

CMD ["bin/web"]

# Interessant articles:
# https://medium.com/magnetis-backstage/how-to-cache-bundle-install-with-docker-7bed453a5800
# https://www.engineyard.com/blog/using-docker-for-rails
# https://github.com/equivalent/scrapbook2/blob/master/archive/blogs/2017-08-rails-assets-pipeline-and-docker.md

# docker build -t drop_n_run_web .

# On server:
# cd projects/drop_n_run
# docker stop ...
# docker run -d -p 80:3010 -v drop_n_run_workarea:/data/work_area --env-file .env.prod_arera iwan/drop_n_run




# docker run -it midilab_web /bin/sh
