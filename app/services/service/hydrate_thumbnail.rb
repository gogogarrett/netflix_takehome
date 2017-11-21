module Service
  module HydrateThumbnail
    extend self

    # Given map containing movie_id, and thumbnail_url, we attempt to create or update a CalendarEvent record
    # with the correct thumbnail url reference.
    #
    # Example input:
    #   { "id": 1, "movie_id": "ee3c0801-9609-49ea-87fa-fcb9b9f438b9", "thumbnail_url": "https://i.imgur.com/g48UBCK.jpg" }
    def call(movie_data)
      event = fetch_calendar_event(movie_data["movie_id"])
      if add_thumbnail(event, movie_data["thumbnail_url"])
        [:success, event]
      else
        [:error, "could not update the thumbnail_url for the movie_id"]
      end
    end

    private

    def fetch_calendar_event(movie_id)
      CalendarEvent.find_or_initialize_by(movie_id: movie_id)
    end

    def add_thumbnail(event, thumbnail_url)
      event.update(thumbnail_url: thumbnail_url)
    end
  end
end
