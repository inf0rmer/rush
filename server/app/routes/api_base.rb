require 'app/routes/base'
require 'sinatra/namespace'
require 'rack/cors'

module Rush
  module Routes

    class ApiBase < Base

      MAX_VERSION = "1.0.0"
      VERSION_MAP = Hash.new([]).merge!(
        "military_operations"      => ["1.0.0"]
      )

      register Sinatra::Namespace

      # enable CORS support for all API endpoints
      # Note: this middleware will be active for all Sinatra apps added in Worker::App after the first App that
      #       inherits from Worker::Routes::ApiBase (order is important)
      use Rack::Cors do |config|
        config.allow do |allow|
          # TODO add domain configuration
          allow.origins '*'
          allow.resource %r{/v(\d*\.\d*\.\d*)},
            methods: [:get, :post, :put, :delete, :options],
            headers: :any
        end
      end

      before %r{/v(\d*\.\d*\.\d*)} do
        handle_version_fallback(params[:captures][0])
      end

      private

      def handle_version_fallback(version)
        return if Versionomy.parse(version) > Versionomy.parse(MAX_VERSION)

        elements = request.fullpath.split("/")
        versions = supported_versions(elements)

        return if versions.empty?

        unless versions.include?(version)
          # path starts with '/' so the first element of elements is an empty string and the version is the second element
          elements[1] = "v#{versions.last}"
          request.path_info = elements.join("/")
        end
      end

      def supported_versions(elements)
        resource = elements.reverse.detect do |element|
          VERSION_MAP[element.pluralize].present?
        end

        VERSION_MAP[resource.to_s.pluralize]
      end

    end

  end
end
