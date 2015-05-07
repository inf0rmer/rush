$:.unshift(File.dirname(__FILE__))

require_relative 'boot'

require 'app'
run Rush::App
