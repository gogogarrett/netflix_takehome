require 'rails_helper'

RSpec.describe Service::HydrateDate do
  let(:movie_data) do
    { "id" => 1, "movie_id" => "ee3c0801-9609-49ea-87fa-fcb9b9f438b9", "launch_date" => "2017-04-28 00:00:00" }
  end

  context "no movie exist with same movie_id" do
    it "creates the CalendarEvent" do
      expect {
        Service::HydrateDate.call(movie_data)
      }.to change {
        CalendarEvent.all.size
      }.from(0).to(1)
    end

    it "sets the launch date in unix" do
      _status, event = Service::HydrateDate.call(movie_data)
      expect(event.launch_date).to eq(1493337600)
    end
  end

  context "movie exist with same movie_id" do
    before do
      CalendarEvent.create(
        movie_id: "ee3c0801-9609-49ea-87fa-fcb9b9f438b9",
        launch_date: 1500000000,
      )
    end

    it "updates the launch_date for the existing CalendarEvent" do
      _status, event = Service::HydrateDate.call(movie_data)
      expect(event.launch_date).to eq(1493337600)
    end
  end
end
