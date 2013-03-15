set :user, 'ec2-user'

set :domain, 'dummy.lrdesign.com'
set :application, 'dummy'      # eg 'rfx'
set :deploy_to, "/var/www/home/#{domain}"
set :keep_releases, 10
set :branch, 'master'
set :rails_env, "production"
set :use_sudo, true

$:.push "."
default_run_options[:pty] = true
#ssh_options[:verbose] = :debug
#ssh_options[:keys] = %w{~/.ssh/lrd_rsa} # uncomment if you need to use a different key
ssh_options[:auth_methods] = %w{publickey password}
ssh_options[:forward_agent] = true

# Overwrite the default deploy start/stop/restart actions with passenger ones
require 'bundler/capistrano'

set :sync_directories, ["public/system"]

set :stages, %w(staging production)
set :default_stage, 'production'

set :repository,  "git@github.com:LRDesign/dummyi.git"
# set :deploy_via, :remote_cache
set :scm, 'git'
# set :git_shallow_clone, 1
set :scm_verbose, true


role(:app) { domain }
role(:web) { domain }
role(:db, :primary => true) { domain }

namespace :deploy do
  task :link_shared_files do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end

  after 'deploy:update_code' do
    link_shared_files
  end

  desc "Recycle the database"
  task :db_install do
    run("cd #{current_path}; /usr/bin/rake db:install RAILS_ENV=#{rails_env}")
  end
end

namespace :gems do
  desc "Install gems"
  task :install, :roles => :app do
    run "cd #{current_path} && #{sudo} rake RAILS_ENV=production gems:install"
  end
end
