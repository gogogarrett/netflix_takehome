module Service
  module HydrateDate
    extend self

    # Given map containing movie_id, and launch_date, we attempt to create or update a CalendarEvent record
    # with a unix timestamp of the launch date.
    #
    # Example input:
    #   { "id" => 1, "movie_id" => "ee3c0801-9609-49ea-87fa-fcb9b9f438b9", "launch_date" => "2017-04-28 00:00:00" },
    def call(movie_data)
      event = fetch_calendar_event(movie_data["movie_id"])
      if add_date_data(event, movie_data["launch_date"])
        [:success, event]
      else
        [:error, "could not update the date for the movie_id"]
      end
    end

    private

    def fetch_calendar_event(movie_id)
      CalendarEvent.find_or_initialize_by(movie_id: movie_id)
    end

    def add_date_data(event, launch_date)
      event.update(launch_date: launch_date_as_unix(launch_date))
    end

    def launch_date_as_unix(launch_date)
      DateTime.parse(launch_date).to_i
    end
  end
end
