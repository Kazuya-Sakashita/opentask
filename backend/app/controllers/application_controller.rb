class ApplicationController < ActionController::API
  include Pundit::Authorization

  private

  def current_user
    User.first
  end
end
