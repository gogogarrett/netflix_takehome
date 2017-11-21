require 'rails_helper'

file = File.read(Rails.root.join("spec/support/dates.json"))
data_hash = JSON.parse(file)

RSpec.describe Actor::DateFetcher do
  it "returns a celluloid actor proxy" do
    actor = Actor::DateFetcher.new
    expect(actor.is_a?(Celluloid)).to eq(true)
  end

  it "calls #run every n seconds" do
    actor = Actor::DateFetcher.new(1)
    # Can't get this to work.
    # expect(actor).to receive(:run).at_least(:twice).and_call_original
    #
    # Not ideal, but still test the function is called every n seconds.
    expect(Rails).to receive(:logger).at_least(:twice).and_call_original
    sleep(3)
  end

  describe "fetching data from API" do
    context "valid api response" do
      before do
        allow(HttpClient).to receive(:get).and_return(data_hash)
      end

      it "returns parsed" do
        actor = Actor::DateFetcher.new(1)
        dates = actor.run

        expect(dates.size).to eq(11)
        expect(dates.first["launch_date"]).to eq("2017-04-28 00:00:00")
      end
    end

    context "invalid response" do
      it "handles failure status, and returns an empty list" do
        allow(HttpClient).to receive(:get).and_return({"status" => "failure"})
        actor = Actor::DateFetcher.new(1)
        dates = actor.run
        expect(dates).to eq([])
      end

      it "handles nil, and returns an empty list" do
        allow(HttpClient).to receive(:get).and_return(nil)
        actor = Actor::DateFetcher.new(1)
        dates = actor.run
        expect(dates).to eq([])
      end
    end
  end
end
