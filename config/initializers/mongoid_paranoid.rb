require 'mongoid/paranoia'

Mongoid::Paranoia.configure do |c|
  c.paranoid_field = :destroyed_at
end
