module Query
  module CalendarEvents
    extend self

    def all_with_data
      CalendarEvent.where.not(
        movie_id: nil,
        title: nil,
        launch_date: nil,
      )
    end
  end
end
