require 'rails_helper'

RSpec.describe Api::V1::CalendarEventsController, type: :controller do
  describe 'GET /calendar_events' do
    context "no valid calendar_events" do
      it 'returns an empty set' do
        get :index, format: :json
        json = JSON.parse(response.body)

        expect(json['data']).to eq([])
        expect(response.status).to eq 200
      end
    end
  end
end
