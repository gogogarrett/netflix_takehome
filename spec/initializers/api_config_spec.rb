require 'rails_helper'

RSpec.describe "Api Configuration" do
  it "properly loads config into rails" do
    api_config = Rails.configuration.api_config

    expect(api_config.dates_service[:url]).to eq("http://dates_service_test.local")
    expect(api_config.dates_service[:auth_token]).to eq("dates_token")
  end
end
