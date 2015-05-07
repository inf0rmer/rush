require 'app/routes/api_base'

module Rush
  module Routes
    module V1_0_0

      class MilitaryOperations < ApiBase
        DEFAULT_SIZE = 10

        namespace '/v1.0.0' do

          get '/military_operations' do
            size = params[:size].to_i
            size = (size > 0) ? size : DEFAULT_SIZE

            operations = {
              military_operations: ::MilitaryOperations.operations(size)
            }

            [200, operations.to_json]
          end

        end
      end

    end
  end
end
