FROM tongueroo/ruby:2.3.1
MAINTAINER Tung Nguyen <tongueroo@gmail.com>

RUN apt-get update && \
  apt-get install -y net-tools netcat && \
  rm -rf /var/lib/apt/lists/* && apt-get clean && apt-get purge

# Packages
# capybara-webkit: libqt4-dev libqtwebkit-dev
RUN apt-get update && \
  apt-get install -y software-properties-common && \
  add-apt-repository ppa:git-core/ppa -y && \
  apt-get update && \
  apt-get install -y \
    build-essential \
    telnet \
    curl \
    vim \
    htop \
    lsof \
    git && \
  rm -rf /var/lib/apt/lists/* && apt-get clean && apt-get purge

# Install bundle of gems
RUN gem install bundler
WORKDIR /tmp
COPY Gemfile* *.gemspec /tmp/
ADD lib/sidekiq_metrics/version.rb /tmp/lib/sidekiq_metrics/version.rb
RUN bundle install && rm -rf /root/.bundle/cache

# Add the app
ENV HOME /root
WORKDIR /app
COPY . /app
RUN bundle install
RUN mkdir -p tmp/cache tmp/pids

# Add development like customizations
ENV TERM xterm

RUN chmod a+x bin/chart
CMD ["bin/chart"]
