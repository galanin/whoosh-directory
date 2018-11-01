namespace :staff do

  task :build do
    on roles(:web) do
      within release_path do
        execute :npm, 'run prod:build'
      end
    end
  end

end
