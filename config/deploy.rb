# config valid for current version and patch releases of Capistrano
lock "~> 3.10.1"

set :application, "zammad"
# set :repo_url, "git@example.com:me/my_repo.git"

set :repo_url, 'https://github.com/kumarmsaravana1988/zammad.git'
set :branch, "helpdesk"
set :user, "sysadmin"
set :passenger_user, 'www-data'
set :use_sudo, true
set :keep_releases, 5
set :rails_env, "production"
set :deploy_via, :copy
# Define where to put your application code
set :deploy_to, "/var/deploy/capistrano/zionsoftwares_helpdesk/"

set :linked_files, %w{config/database.yml config/application.yml}
set :linked_dirs, %w{public/system}


set :pty, true

set :format, :pretty

set :passenger_roles, :app
set :passenger_restart_runner, :sequence
set :passenger_restart_wait, 5
set :passenger_restart_limit, 2
set :passenger_restart_with_sudo, true
set :passenger_environment_variables, {}
set :passenger_restart_command, 'passenger-config restart-app'
set :passenger_restart_options, -> { "#{deploy_to} --ignore-app-not-running" }

namespace :deploy do

  desc "change permission to passenger_user "
  task :canvasuser_permission do
    on roles(:app) do
      within "#{current_path}" do
        with rails_env: "#{fetch(:stage)}" do
          sudo "mkdir -p #{current_path}/log"
          sudo "mkdir -p #{current_path}/tmp/pids"
          sudo "chown #{fetch(:passenger_user)} #{current_path}/config/environment.rb"
          sudo "chown #{fetch(:passenger_user)} #{current_path}/Gemfile.lock"
          sudo "chown #{fetch(:passenger_user)} #{current_path}/config.ru"
          sudo "chown -R #{fetch(:passenger_user)} #{current_path}/log"
          sudo "chown -R #{fetch(:passenger_user)} #{current_path}/public"
          sudo "chown -R #{fetch(:passenger_user)}:#{fetch(:user)} #{current_path}/tmp/"
          sudo "chmod 777 -R #{current_path}/tmp/cache/"
        end
      end
    end
  end

  before :cleanup, :cleanup_permissions

  desc 'Set permissions on old releases before cleanup'
  task :cleanup_permissions do
    on release_roles :all do |host|
      releases = capture(:ls, '-x', releases_path).split
      if releases.count >= fetch(:keep_releases)
        info "Cleaning permissions on old releases"
        directories = (releases - releases.last(1))
        if directories.any?
          directories.each do |release|
            within releases_path.join(release) do
              execute :sudo, :chown, '-R', fetch(:user), '.'
            end
          end
        else
          info t(:no_old_releases, host: host.to_s, keep_releases: fetch(:keep_releases))
        end
      end
    end
  end

end

after 'deploy', 'deploy:canvasuser_permission'
after 'deploy', 'passenger:restart'

# Set the post-deployment instructions here.
# Once the deployment is complete, Capistrano
# will begin performing them as described.
# To learn more about creating tasks,
# check out:
# http://capistranorb.com/

# namespace: deploy do

#   desc 'Restart application'
#   task :restart do
#     on roles(:app), in: :sequence, wait: 5 do
#       # Your restart mechanism here, for example:
#       execute :touch, release_path.join('tmp/restart.txt')
#     end
#   end

#   after :publishing, :restart

#   after :restart, :clear_cache do
#     on roles(:web), in: :groups, limit: 3, wait: 10 do
#       # Here we can do anything such as:
#       # within release_path do
#       #   execute :rake, 'cache:clear'
#       # end
#     end
#   end

# end
# # Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
