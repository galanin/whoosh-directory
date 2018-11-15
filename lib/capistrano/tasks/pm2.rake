namespace :pm2 do

  task :reload do
    on roles(:web) do
      within shared_path do
        pm2_path = fetch(:pm2_path, 'pm2')
        execute pm2_path, 'reload', 'ecosystem.config.js', '--env', 'production'
      end
    end
  end

end
