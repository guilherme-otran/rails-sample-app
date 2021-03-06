FROM guilhermeotran/ruby23centos7

# Install apt based dependencies required to run Rails as
# well as RubyGems. As the Ruby image itself is based on a
# Debian image, we use apt-get to install those.
# RUN apt-get update && apt-get install -y \
#  build-essential \
#  nodejs

# Configure the main working directory. This is the base
# directory used in any further RUN, COPY, and ENTRYPOINT
# commands.
# RUN mkdir -p /app
WORKDIR /opt/app-root

# Copy the Gemfile as well as the Gemfile.lock and install
# the RubyGems. This is a separate step so the dependencies
# will be cached unless changes to one of those two files
# are made.
COPY Gemfile Gemfile.lock ./
RUN bundle config build.nokogiri --use-system-libraries && bundle install --path ./bundle

# Copy the main application
COPY . ./

# Expose port 3000 to the Docker host, so we can access it
# from the outside.
EXPOSE 3000
VOLUME /opt/app-root/public
VOLUME /opt/app-root/log

USER root
RUN chown -R 1001:0 /opt/app-root/db && \
    chmod -R 755 /opt/app-root/db && \
    chown -R 1001:0 /opt/app-root/log && \
    chown -R 1001:0 /opt/app-root/public

USER 1001

RUN ["/opt/app-root/entrypoint.sh", "bundle exec rake db:create db:migrate"]

# Configure an entry point, so we don't need to specify
# "bundle exec" for each of our commands.
ENTRYPOINT ["/opt/app-root/entrypoint.sh"]

# The main command to run when the container starts. Also
# tell the Rails dev server to bind to all interfaces by
# default.
CMD ["rails", "server", "-b", "0.0.0.0"]
