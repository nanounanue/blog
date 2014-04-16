set :stage, :production
set :branch,"master"

set :server_name, "blog"
set :full_app_name, "#{fetch(:application)}_#{fetch(:stage)}"

server '107.170.81.168', user: 'deploy', roles: %w{web app db}, primary: true

set :deploy_to, "/home/#{fetch(:deploy_user)}/apps/#{fetch(:full_app_name)}"

set :rails_env, :production

set :unicorn_worker_count, 2

set :enable_ssl, false
