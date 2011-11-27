set :application, "deviseomni"
set :repository,  "git@github.com:mjpete3/deviseomni.git"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "10.10.1.116"                          # Your HTTP server, Apache/etc
role :app, "10.10.1.116"                          # This may be the same as your `Web` server
role :db,  "10.10.1.116", :primary => true # This is where Rails migrations will run

set :user, "mjpete"
set :deploy_to, "/var/www/html/#{application}"
set :use_sudo, false
set :deploy_via, :remote_cache

#this pain in the ass option allowed the remote sever to authenticate to github
default_run_options[:pty] = true

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:

after "deploy", "deploy:bundle_gems"
after "deploy:bundle_gems", "deploy:restart"

 namespace :deploy do
   task :bundle_gems do
     run "cd #{deploy_to}/current && bundle install --path vendor/gems"
   end
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "touch #{File.join(current_path,'tmp','restart.txt')}"
   end
 end