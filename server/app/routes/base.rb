require 'sinatra/namespace'

module Rush
  module Routes

    class Base < Sinatra::Base

      before do
        content_type :json
      end

    end

  end
end
