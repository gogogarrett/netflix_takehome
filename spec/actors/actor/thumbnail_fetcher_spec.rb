require 'rails_helper'

file = File.read(Rails.root.join("spec/support/thumbnails.json"))
data_hash = JSON.parse(file)

RSpec.describe Actor::ThumbnailFetcher do
  it "returns a celluloid actor proxy" do
    allow(HttpClient).to receive(:get).and_return(data_hash)
    actor = Actor::ThumbnailFetcher.new
    expect(actor.is_a?(Celluloid)).to eq(true)
  end

  describe "Fetching data from API" do
    context "valid api response" do
      before do
        allow(HttpClient).to receive(:get).and_return(data_hash)
      end

      it "should delegate to the HydrateThumbnail service for each movie data" do
        expect(Service::HydrateThumbnail).to receive(:call).exactly(11).times
        actor = Actor::ThumbnailFetcher.new(100)
        dates = actor.run
      end
    end

    context "invalid response" do
      it "handles failure status, and returns an empty list" do
        allow(HttpClient).to receive(:get).and_return({"status" => "failure"})
        expect(Service::HydrateThumbnail).to receive(:call).exactly(0).times
        actor = Actor::ThumbnailFetcher.new(100)
        dates = actor.run
      end

      it "handles nil, and returns an empty list" do
        allow(HttpClient).to receive(:get).and_return(nil)
        expect(Service::HydrateThumbnail).to receive(:call).exactly(0).times
        actor = Actor::ThumbnailFetcher.new(100)
        dates = actor.run
      end
    end
  end

  describe "Service returning a failure" do
    it "should not terminate/crash the actor" do
      allow(Service::HydrateThumbnail).to receive(:call).and_return([:error, {}])
      actor = Actor::ThumbnailFetcher.new(100)

      expect {
        actor.run
      }.to_not raise_error
    end
  end
end
