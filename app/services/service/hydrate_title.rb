module Service
  module HydrateTitle
    extend self

    # Given map containing movie_id, and title, we attempt to create or update a CalendarEvent record
    # with the correct title.
    #
    # Example input:
    #   { "id" => 1, "movie_id" => "ee3c0801-9609-49ea-87fa-fcb9b9f438b9", "title" => "Black Is The New Orange: Season 1" }
    def call(movie_data)
      event = fetch_calendar_event(movie_data["movie_id"])
      if add_title(event, movie_data["title"])
        [:success, event]
      else
        [:error, "could not update the title for this movie_id"]
      end
    end

    private

    def fetch_calendar_event(movie_id)
      CalendarEvent.find_or_initialize_by(movie_id: movie_id)
    end

    def add_title(event, title)
      event.update(title: title)
    end
  end
end
