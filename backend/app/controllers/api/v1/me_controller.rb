class Api::V1::MeController < ApplicationController
  def show
    render json: current_user
  end
end
