set :application, "onox"
set :scm, :git
set :repository,  "git://github.com/agarie/so-zetta-slow.git"

set :domain, "onox.com.br"
set :user, "sirauron"
set :use_sudo, false
set :shell, '/bin/bash'

set :deploy_to, "/home/#{user}/onox"
set :keep_releases, 3

server "#{domain}", :app, :web, :db, :primary => true

after "deploy:update", "deploy:jekyll"
namespace :deploy do
  [:start, :stop, :restart, :finalize_update].each do |t|
      desc "#{t} task is a no-op with jekyll"
      task t, :roles => :app do nil end
    end
  
  task :jekyll do
    prepare_dir
    install_gems
    generate_site
    post_generate
  end
  
  task :prepare_dir do
    commands = []
    commands << "cd #{release_path}"
    commands << "mkdir -p jekyll"
    commands << "mv `ls | grep -riv -E 'REVISION|jekyll'` jekyll"
    commands << "cd jekyll"
    
    run "#{commands.join(' && ')}"
  end
  
  task :install_gems do
    run "cd #{release_path}/jekyll && bundle install --without test"
  end
  
  task :generate_site do
    run "cd #{release_path}/jekyll && bundle exec jekyll build"
  end  
  
  task :post_generate do
    commands = []
    commands << "mv #{release_path}/jekyll/_site #{release_path}/site"
    commands << "cd #{release_path}"
    commands << "rm -rf jekyll"
    
    run "#{commands.join(' && ')}"
  end  
end