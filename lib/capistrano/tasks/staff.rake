namespace :staff do

  task :build do
    on roles(:web) do
      within release_path do
        execute :npm, 'run prod:build'
      end
    end
  end


  task :import do
    on roles(:api) do
      within release_path do
        with rack_env: fetch(:rack_env) do
          execute :rake, "import[#{ENV['which']}]"
        end
      end
    end
  end


  task :rebuild_index do
    on roles(:api) do
      within release_path do
        with rack_env: fetch(:rack_env) do
          execute :rake, 'rebuild_index'
        end
      end
    end
  end


  task :full_import do
    on roles(:api) do
      within release_path do
        with rack_env: fetch(:rack_env) do
          execute :rake, "import[#{ENV['which']}]"
          execute :rake, 'rebuild_index'
        end
      end
    end
  end


  task :rebuild_photos do
    on roles(:api) do
      within release_path do
        with rack_env: fetch(:rack_env) do
          execute :rake, 'rebuild_photos'
        end
      end
    end
  end

end
