#!/usr/bin/env bash
set -euo pipefail

if [ -f Gemfile ]; then
  echo "Gemfile already exists. Rails app generation skipped."
else
  tmp_root="$(mktemp -d)"
  tmp_app="${tmp_root}/app"
  trap 'rm -rf "${tmp_root}"' EXIT

  rails new "${tmp_app}" \
    --database=postgresql \
    --javascript=esbuild \
    --skip-docker \
    --skip-git

  shopt -s dotglob
  cp -Rn "${tmp_app}/"* .
  shopt -u dotglob
fi

bundle install

if [ -f package.json ]; then
  yarn add react react-dom
  yarn add --dev @types/react @types/react-dom
fi

if [ -f config/database.yml ]; then
  ruby -ryaml -e '
    path = "config/database.yml"
    config = YAML.load_file(path, aliases: true)
    %w[development test].each do |env|
      config[env] ||= {}
      config[env]["host"] = "<%= ENV.fetch(\"DATABASE_HOST\", \"db\") %>"
      config[env]["port"] = "<%= ENV.fetch(\"DATABASE_PORT\", 5432) %>"
      config[env]["username"] = "<%= ENV.fetch(\"DATABASE_USERNAME\", \"postgres\") %>"
      config[env]["password"] = "<%= ENV.fetch(\"DATABASE_PASSWORD\", \"postgres\") %>"
    end
    File.write(path, config.to_yaml)
  '
fi

bin/rails db:prepare

echo
echo "Rails + React setup complete."
echo "Run: bin/dev"
