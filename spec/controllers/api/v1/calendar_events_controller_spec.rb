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

    context "with valid events" do
      let!(:missing_info_movie) do
        CalendarEvent.create(
          movie_id: "movie_1",
          title: "The Matrix",
          launch_date: nil,
        )
      end
      let!(:valid_movie) do
        CalendarEvent.create(
          movie_id: "movie_2",
          title: "Battlestar Galactica",
          thumbnail_url: "https://i.imgur.com/Tgs8iJD.gif",
          launch_date: 1493337600,
        )
      end

      it 'returns calendar_events for the client' do
        get :index, format: :json
        json = JSON.parse(response.body)

        expect(json['data'].size).to eq(1)
        expect(json['data']).to include(hash_including(
          {
            "movie_id" => "movie_2",
            "title" => "Battlestar Galactica",
            "launch_date" => 1493337600,
            "thumbnail_url" => "https://i.imgur.com/Tgs8iJD.gif",
          },
        ))
        expect(response.status).to eq 200
      end
    end
  end
end
