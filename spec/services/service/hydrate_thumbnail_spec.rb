require 'rails_helper'

RSpec.describe Service::HydrateThumbnail do
  let(:movie_data) do
    { "id" => 1, "movie_id" => "ee3c0801-9609-49ea-87fa-fcb9b9f438b9", "thumbnail_url" => "https://i.imgur.com/g48UBCK.jpg" }
  end

  context "no movie exist with same movie_id" do
    it "creates the CalendarEvent" do
      expect {
        Service::HydrateThumbnail.call(movie_data)
      }.to change {
        CalendarEvent.all.size
      }.from(0).to(1)
    end

    it "sets the thumbnail_url" do
      _status, event = Service::HydrateThumbnail.call(movie_data)
      expect(event.thumbnail_url).to eq("https://i.imgur.com/g48UBCK.jpg")
    end
  end

  context "movie exist with same movie_id" do
    before do
      CalendarEvent.create(
        movie_id: "ee3c0801-9609-49ea-87fa-fcb9b9f438b9",
        thumbnail_url: "https://i.imgur.com/CtnhjDB.jpg",
      )
    end

    it "updates the launch_date for the existing CalendarEvent" do
      _status, event = Service::HydrateThumbnail.call(movie_data)
      expect(event.thumbnail_url).to eq("https://i.imgur.com/g48UBCK.jpg")
    end
  end
end
