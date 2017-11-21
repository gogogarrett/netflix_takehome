module Actor
  class DateFetcher
    include Celluloid

    def initialize(refresh_rate = 15)
      every(refresh_rate) { run }
    end

    def run
      Rails.logger.debug "polling dates"

      ActiveRecord::Base.transaction do
        dates_data.each do |date_data|
          result, _event = ::Service::HydrateDate.call(date_data)
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
