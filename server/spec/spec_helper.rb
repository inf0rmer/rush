if ENV['CODECLIMATE_REPO_TOKEN']
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.configure do |config|
    config.path_prefix = "server"
    config.git_dir = "../"
  end
  CodeClimate::TestReporter.start
else
  require 'simplecov'
end

ENV['RUBY_ENV'] = 'test'
require_relative '../boot'

require 'rack/test'

$: << File.expand_path('../', __FILE__)

require File.expand_path '../../app.rb', __FILE__

set :environment, :test

module RSpecMixin
  include Rack::Test::Methods

  def app() Rush::App end
end

RSpec.configure do |config|

  config.include RSpecMixin
  config.include JsonSpec::Helpers

end

# Helpers
def post_json(url, data)
  post url, data.to_json, { CONTENT_TYPE: "application/json" }
end
