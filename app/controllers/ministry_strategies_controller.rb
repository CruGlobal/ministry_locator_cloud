class MinistryStrategiesController < ApplicationController
  def index
    render json: MinistryStrategy.order(:name)
  end
end
