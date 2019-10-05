FROM ruby:2.2-alpine
ENV POST_SERVICE_HOST post
ENV POST_SERVICE_PORT 5000
ENV COMMENT_SERVICE_HOST comment
ENV COMMENT_SERVICE_PORT 9292
ENV APP_HOME /app

RUN mkdir $APP_HOME
WORKDIR $APP_HOME
ADD Gemfile* $APP_HOME/

RUN  apk add --update build-base ruby-dev curl \
    && bundle install \
    && apk del build-base ruby-dev

ADD . $APP_HOME

CMD ["puma"]
