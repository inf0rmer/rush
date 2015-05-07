require "spec_helper.rb"

describe "Routes::MilitaryOperations" do

  describe "GET /v1.0.0/military_operations" do

    subject { get "/v1.0.0/military_operations" }

    let(:operations) { ["One", "Two", "Three"] }

    let(:expected_response_body) do
      {
        military_operations: operations
      }
    end

    before :each do
      allow(MilitaryOperations).to receive(:operations) { operations }
    end

    it "responds with 200 OK" do
      subject
      expect(last_response).to be_ok
    end

    it "responds with an array of names" do
      subject

      expect(last_response.body).to be_json_eql(expected_response_body.to_json)
    end

    context "when a size parameter is passed" do
      context "when it is a valid integer" do
        subject { get "/v1.0.0/military_operations?size=#{size}" }

        let(:size) { 5 }

        it "calls MilitaryOperations#operations with that amount" do
          expect(MilitaryOperations).to receive(:operations).with(size)

          subject
        end
      end

      context "when it is not a valid integer" do
        subject { get "/v1.0.0/military_operations?size=#{size}" }

        let(:size)         { "foo" }
        let(:default_size) { 10 }

        it "calls MilitaryOperations#operations with a default amount" do
          expect(MilitaryOperations).to receive(:operations).with(default_size)

          subject
        end
      end
    end

  end
end
