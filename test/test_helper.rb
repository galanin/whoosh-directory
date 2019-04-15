require 'minitest/spec'
require 'minitest/autorun'
require 'rack/test'
require 'dotenv/load'
require_relative '../api.rb'

ENV['RACK_ENV'] = 'development'
