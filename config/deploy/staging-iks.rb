set :repo_url, 'https://github.com/galanin/whoosh-directory.git'
set :deploy_to, '/home/deployer/staff_staging'
set :branch, :master

server 'staff', user: 'deployer', roles: %w{api web}, ssh_options: { forward_agent: true }
