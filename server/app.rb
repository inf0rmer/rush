require 'sinatra'
require 'sinatra/base'
require 'app/routes'

module Rush
  class App < Sinatra::Base

    configure do
      set :root, APP_ROOT.to_s
    end

    use Routes::V1_0_0::MilitaryOperations
  end
end
