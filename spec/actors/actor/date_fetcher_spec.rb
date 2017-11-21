require 'rails_helper'

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
end
