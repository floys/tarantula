set :application, "tarantula"

set :domain, "192.168.24.181"
role :web, domain
role :app, domain
role :db, domain, :primary => true

set :user, "user"
set :deploy_to, "/home/#{user}/#{application}"
set :use_sudo, false

default_run_options[:pty] = true
default_environment['LD_LIBRARY_PATH'] = '/usr/lib/oracle/11.2/client64/lib/'
default_environment['ORACLE_HOME']='/usr/lib/oracle/11.2/client64/'
default_environment['NLS_LANG']='AMERICAN_CIS.UTF8'

set :repository, "git@github.com:evgeniy-khatko/tarantula.git"
set :branch, "master"
set :scm, "git"

set :scm_verbose, true
set :deploy_via, :remote_cache

set :bundle_flags, "--quiet"

set :app_port, 80

namespace :deploy do
 task(:start) {}
 task(:stop) {}

 desc 'Restart Application'
 task :restart, :roles => :app, :except => { :no_release => true } do
	 run "#{try_sudo} touch #{File.join current_path,'tmp','restart.txt'}"
 end

 task :my, :roles => :app do
	 run "echo 1"
 end
end

