FROM ruby:2.6.10

# Install dependencies
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

# Install Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install yarn


# Set an environment variable where the Rails app is installed to inside of Docker image:
ENV RAILS_ROOT /var/www/inviti
RUN mkdir -p $RAILS_ROOT

# Set working directory, where the commands will be ran:
WORKDIR $RAILS_ROOT

# A place for Activestorage
RUN mkdir /storage

# Setting env up
# ENV RAILS_ENV='production'
# ENV RACK_ENV='production'
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8


ENV BUNDLE_PATH /gems

# Adding gems
# COPY Gemfile Gemfile
# COPY Gemfile.lock Gemfile.lock

ENV HTTP_PROXY http://10.77.8.27:3128
ENV HTTPS_PROXY http://10.77.8.27:3128
ENV http_proxy http://10.77.8.27:3128

RUN gem install bundler
RUN gem update bundler

# RUN bundle install --jobs 20 --retry 5 --without development test

# Adding project files
# COPY . .
ADD . $RAILS_ROOT

ENV HTTP_PROXY ""
ENV HTTPS_PROXY ""
ENV http_proxy ""

# RUN bundle exec rake assets:precompile

EXPOSE 3000
CMD ["bin/web"]
