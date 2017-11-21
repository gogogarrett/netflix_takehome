module Actor
  class DateFetcher
    include Celluloid

    def initialize(refresh_rate = 15)
      every(refresh_rate) { run }
    end

    def run
      Rails.logger.debug "polling dates"
    end
  end
end
