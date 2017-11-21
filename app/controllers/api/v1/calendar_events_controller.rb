class Api::V1::CalendarEventsController < ApplicationController
  def index
    render json: { data: [] }
  end
end
