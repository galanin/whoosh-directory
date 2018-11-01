namespace :pm2 do

  task :reload do
    on roles(:web) do
      within shared_path do
        execute :pm2, 'reload ecosystem.config.js --env production'
      end
    end
  end

end
