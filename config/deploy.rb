# -*- coding: utf-8 -*-
# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'blog'
set :deploy_user, 'deploy'

# Detalles del repo
set :scm, :git
set :repo_url, 'git@github.com:nanounanue/blog.git'


# Rbenv
set :rbenv_type, :system
set :rbenv_ruby, '2.0.0p247'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}

# ¿Cuántas versiones anteriores?
set :keep_releases, 5

# Archivos que queremos symlink
set :linked_files, %w{config/database.yml}

# Directorios que queremos de symlink
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# ¿Qué pruebas se deben de ejecutar?
set :tests, []


set(:config_files, %w(
nginx.conf
database.example.yml
log_rotation
monit
unicorn.rb
unicorn_init.sh
))

set(:executable_config_files, %w(
unicorn_init.sh
))


set(:symlinks, [
                {
                  source: "nginx.conf",
                  link: "/etc/nginx/sites-enabled/#{full_app_name}"
                },
                {
                  source: "unicorn_init.sh",
                  link: "/etc/init.d/unicorn_#{full_app_name}"
                },
                {
                  source: "log_rotation",
                  link: "/etc/logrotate.d/#{full_app_name}"
                },
                {
                  source: "monit",
                  link: "/etc/monit/conf.d/#{full_app_name}.conf"
                }
               ]
)


namespace :deploy do
  before :deploy, "deploy:check_revision"
  before :deploy, "deploy:run_tests"

  after ':deploy:symlink:shared', 'deploy:compile_assets_locally'
  after :finishing, 'deploy:cleanup'


  before 'deploy:setup_config', 'nginx:remove_default_vhost'

  after 'deploy:setup_config', 'nginx:reload'

  after 'deploy:setup_config', 'monit:restart'

  after 'deploy:publishing', 'deploy:restart'

end
