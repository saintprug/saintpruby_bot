FROM ruby:2.6.3

ENV LANG="en_US.UTF-8" \
    APP_HOME="/app" \
    BUNDLE_SILENCE_ROOT_WARNING="1"

RUN mkdir -p $APP_HOME

WORKDIR $APP_HOME

RUN bundle config --global git.allow_insecure true && \
    bundle config github.https true

VOLUME $APP_HOME
