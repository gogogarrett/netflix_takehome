require 'spec_helper'
require_relative '../../lib/http_client'

RSpec.describe HttpClient do
  context "successful request" do
    it "responds with valid json" do
      stub_request(:get, "https://gogogarrett.local:80/").
        to_return(status: 200, body: {abc: 123}.to_json, headers: {})

      expect(HttpClient.get("http://gogogarrett.local")).to eq({"abc" => 123})
    end

    it "allows headers to be sent" do
      stub_request(:get, "https://gogogarrett.local:80/").
        with { |request| request.headers["Authorization"] == "abc" }.
        to_return(status: 200, body: {abc: 123}.to_json, headers: {})

      HttpClient.get("http://gogogarrett.local", { 'Authorization' => "abc" })
    end
  end

  context "failed request" do
    before do
      stub_request(:get, "https://gogogarrett.local:80/").
        to_return(status: 500, body: nil, headers: {})
    end

    it "returns a map with a failure status" do
      expect(HttpClient.get("http://gogogarrett.local")).to eq({"status" => "failure"})
    end
  end
end
