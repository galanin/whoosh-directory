# This file is used by Rack-based servers to start the application.

require 'dotenv/load'
require_relative 'api'

run Staff::API
