class Api::V1::MeController < ApplicationController
  def show
    render json: UserSerializer.call(current_user)
  end
end
