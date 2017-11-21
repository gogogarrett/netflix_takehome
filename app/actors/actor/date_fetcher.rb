module Actor
  class DateFetcher
    include Celluloid

    def initialize(refresh_rate = 15)
      every(refresh_rate) { run }
    end

    def run
      Rails.logger.debug "polling dates"

      dates_data
    end

    private

    def dates_data
      response_data = HttpClient.get(dates_url, headers)
      parse_data(response_data)
    end

    def parse_data(response_data)
      response_data && response_data["data"] || []
    end

    def dates_url
      Rails.configuration.api_config.dates_service[:url]
    end

    def headers
      { 'Authorization' => Rails.configuration.api_config.dates_service[:auth_token] }
    end
  end
end
