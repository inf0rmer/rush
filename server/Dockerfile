FROM ruby:2.2.1
MAINTAINER Bruno Abrantes

WORKDIR /root/server

RUN gem update --system

RUN gem install bundler

COPY Gemfile /root/server/Gemfile
COPY Gemfile.lock /root/server/Gemfile.lock
RUN cd /root/server; bundle install

CMD ["foreman", "start", "-c", "web=1"]

EXPOSE 8080
