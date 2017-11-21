require 'rails_helper'

RSpec.describe Service::HydrateTitle do
  let(:movie_data) do
    { "id" => 1, "movie_id" => "ee3c0801-9609-49ea-87fa-fcb9b9f438b9", "title" => "Black Is The New Orange: Season 1" }}
  end

  context "no movie exist with same movie_id" do
    it "creates the CalendarEvent" do
      expect {
        Service::HydrateTitle.call(movie_data)
      }.to change {
        CalendarEvent.all.size
      }.from(0).to(1)
    end

    it "sets the launch date in unix" do
      _status, event = Service::HydrateTitle.call(movie_data)
      expect(event.title).to eq("Black Is The New Orange: Season 1")
    end
  end

  context "movie exist with same movie_id" do
    before do
      CalendarEvent.create(
        movie_id: "ee3c0801-9609-49ea-87fa-fcb9b9f438b9",
        title: "Stranger Things 2.",
      )
    end

    it "updates the title for the existing CalendarEvent" do
      _status, event = Service::HydrateTitle.call(movie_data)
      expect(event.title).to eq("Black Is The New Orange: Season 1")
    end
  end
end
