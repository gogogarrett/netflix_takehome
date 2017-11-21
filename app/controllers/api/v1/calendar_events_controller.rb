class Api::V1::CalendarEventsController < ApplicationController
  def index
    render json: {
      data: Query::CalendarEvents.all_with_data
    }
  end
end
