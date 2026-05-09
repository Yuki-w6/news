FROM ruby:3.3-bookworm

ARG NODE_MAJOR=22
ARG RAILS_VERSION="~> 7.2.0"

ENV BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3 \
    GEM_HOME=/usr/local/bundle \
    PATH=/workspace/bin:/usr/local/bundle/bin:/usr/local/node/bin:$PATH

RUN apt-get update -qq \
    && apt-get install -y --no-install-recommends \
      build-essential \
      ca-certificates \
      curl \
      git \
      gnupg \
      libpq-dev \
      pkg-config \
      postgresql-client \
      vim \
      less \
    && mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_${NODE_MAJOR}.x nodistro main" > /etc/apt/sources.list.d/nodesource.list \
    && apt-get update -qq \
    && apt-get install -y --no-install-recommends nodejs \
    && corepack enable \
    && gem update --system \
    && gem install rails -v "${RAILS_VERSION}" \
    && gem install foreman \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

EXPOSE 3000

CMD ["sleep", "infinity"]
