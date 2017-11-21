require 'rails_helper'

RSpec.describe Query::CalendarEvents do
  context "events with required data" do
    let!(:valid_movie_1) do
      CalendarEvent.create(
        movie_id: "movie_1",
        title: "Battlestar Galactica",
        launch_date: 1493337600,
      )
    end
    let!(:valid_movie_2) do
      CalendarEvent.create(
        movie_id: "movie_2",
        title: "Bill Nye the Science Guy: Volumn 1",
        launch_date: 1493337600,
      )
    end
    let!(:missing_info_movie) do
      CalendarEvent.create(
        movie_id: "movie_3",
        title: "The Matrix",
        launch_date: nil,
      )
    end

    it "returns all the events with valid data" do
      expect(Query::CalendarEvents.all_with_data).to eq([valid_movie_1, valid_movie_2])
    end
  end

  context "no events" do
    it "returns an empty list" do
      expect(Query::CalendarEvents.all_with_data).to eq([])
    end
  end
end
