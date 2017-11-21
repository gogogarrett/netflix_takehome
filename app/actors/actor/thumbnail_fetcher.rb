module Actor
  class ThumbnailFetcher
    include Celluloid

    def initialize(refresh_rate = 15)
      every(refresh_rate) { run }
    end

    def run
      Rails.logger.debug "polling thumbnails"

      ActiveRecord::Base.transaction do
        thumbnails_data.each do |thumbnail_data|
          result, _event = ::Service::HydrateThumbnail.call(thumbnail_data)
          if error?(result)
            raise ActiveRecord::Rollback
          end
        end
      end
    end

    private

    def error?(result)
      result == :error
    end

    def thumbnails_data
      response_data = HttpClient.get(dates_url, headers)
      parse_data(response_data)
    end

    def parse_data(response_data)
      response_data && response_data["data"] || []
    end

    def dates_url
      Rails.configuration.api_config.thumbnails_service[:url]
    end

    def headers
      { 'Authorization' => Rails.configuration.api_config.thumbnails_service[:auth_token] }
    end
  end
end
