class ApplicationController < ActionController::API
  include Pundit::Authorization
  include ProblemRenderable

  private

  def current_user
    User.first
  end
end
