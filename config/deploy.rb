set :application, "tarantula"

set :domain, "192.168.24.181"
role :web, domain
role :app, domain
role :db, domain, :primary => true

set :user, "user"
set :deploy_to, "/home/#{user}/#{application}"
set :use_sudo, false

default_run_options[:pty] = true
default_environment['LD_LIBRARY_PATH'] = "#{ENV["ORACLE_HOME"]}/lib/"
default_environment['NLS_LANG']='AMERICAN_CIS.UTF8'

set :repository, "git@github.com:evgeniy-khatko/tarantula.git"
set :branch, "master"
set :scm, "git"

set :scm_verbose, true

#set :bundle_flags, "--quiet"

set :app_port, 80

namespace :deploy do
	task(:start) {}
	task(:stop) {}

	desc 'Restart Application'
	task :restart, :roles => :app, :except => { :no_release => true } do
	 run "#{try_sudo} touch #{File.join current_path,'tmp','restart.txt'}"
	end

	desc "Symlinks the database.yml"
	task :symlink_db, :roles => :app do
		run "ln -nfs #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
	end

	task :my, :roles => :app do
	 run "echo 1"
	end
end

after 'deploy:update_code', 'deploy:symlink_db'
