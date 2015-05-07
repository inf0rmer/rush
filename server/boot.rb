# Set ENV variables
require 'dotenv'
Dotenv.load

# Initializes load path with gems listed in Gemfile
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __FILE__)
ENV['RUBY_ENV'] ||= 'development'
require 'bundler/setup' if File.exist?(ENV['BUNDLE_GEMFILE'])

# Requires gems listed in Gemfile
Bundler.require(:default, ENV['RUBY_ENV'])

# Requires Ruby standard library modules
require 'base64'
require 'erb'
require 'logger'
require 'yaml'
require 'pathname'
require 'json'

# Requires ActiveSupport core extensions
require 'active_support'
require 'active_support/core_ext'

# Define APP_ROOT
APP_ROOT = Pathname.new(File.expand_path('..', __FILE__))

$: << File.expand_path('../', __FILE__)
