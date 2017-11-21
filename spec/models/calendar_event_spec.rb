require 'rails_helper'

RSpec.describe CalendarEvent, type: :model do
  it "has a uniq movie_id" do
    CalendarEvent.create(movie_id: 1)
    expect {
      CalendarEvent.create(movie_id: 1)
    }.to raise_error(ActiveRecord::RecordNotUnique)
  end
end
