require "spec_helper.rb"

describe "Routes::ApiBase" do

  let(:version_map_constant) { "Rush::Routes::ApiBase::VERSION_MAP" }
  let(:max_version_constant) { "Rush::Routes::ApiBase::MAX_VERSION" }

  def mock_app(base=Rush::Routes::ApiBase, &block)
    @app = Sinatra.new(base, &block)
  end

  def app
    Rack::Lint.new(@app)
  end

  describe "versioning" do
    before :each do
      stub_const(max_version_constant, max_version)
      stub_const(version_map_constant, Hash.new([]).merge!(version_map))
    end

    context "When the routed resource supports the given version" do
      let (:version) { "v1.0.0" }
      let (:version_map) {
        {
          "things" => ['1.0.0', '2.0.0']
        }
      }
      let(:max_version) { "2.0.0" }

      subject { get "/#{version}/things" }

      before :each do
        mock_app do
          get("/v1.0.0/things") { "v1.0.0" }
        end
      end

      it "uses that route" do
        subject
        expect(last_response.body).to eq("v1.0.0")
      end
    end

    context "When the given version exceeds MAX_VERSION" do
      let (:version) { "v1000.0.0" }
      let (:version_map) {
        {
          "things" => ['1.0.0']
        }
      }
      let(:max_version) { "1.0.0" }

      subject { get "/#{version}/things" }

      before :each do
        mock_app do
          get("/v1.0.0/things") { "v1.0.0" }
        end
      end

      it "responds with 404 Not Found" do
        subject
        expect(last_response.status).to eq(404)
      end
    end

    context "When the routed resource does not support the given version" do
      let (:version) { "v3.0.0" }
      let (:version_map) {
        {
          "things" => ['1.0.0', '2.0.0']
        }
      }
      let(:max_version) { "3.0.0" }

      subject { get "/#{version}/things" }

      before :each do
        mock_app do
          get("/v2.0.0/things") { "v2.0.0" }
        end
      end

      it "falls back to the last supported version" do
        subject
        expect(last_response.body).to eq("v2.0.0")
      end

      context "When the routed resource is not a collection" do
        subject { get "/#{version}/thing/123" }

        before :each do
          mock_app do
            get("/v2.0.0/thing/:id") { "member v2.0.0" }
          end
        end

        it "uses the collection definition in VERSION_MAP" do
          subject
          expect(last_response.body).to eq("member v2.0.0")
        end
      end

      context "When the routed resource is a subresource" do
        let (:version_map) {
          {
            "resources" => ['1.0.0', '2.0.0'],
            "subresources" => ['1.0.0']
          }
        }

        subject { get "/#{version}/resources/123/subresources" }

        before :each do
          mock_app do
            get("/v1.0.0/resources/:id/subresources") { "subresource v1.0.0" }
          end
        end

        it "uses the subresource definition in VERSION_MAP" do
          subject
          expect(last_response.body).to eq("subresource v1.0.0")
        end
      end
    end
  end

end
