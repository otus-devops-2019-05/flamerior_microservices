FROM ruby:2.2-alpine

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ENV COMMENT_DATABASE_HOST comment_db
ENV COMMENT_DATABASE comments

ADD Gemfile* $APP_HOME/
RUN apk add --no-cache build-base \
    && bundle install \
    && apk del build-base
ADD . $APP_HOME

CMD ["puma"]
