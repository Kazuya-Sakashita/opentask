class ApplicationController < ActionController::API
  include Pundit::Authorization
  include ProblemRenderable

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from Pundit::NotAuthorizedError, with: :render_forbidden

  private

  def current_user
    User.first
  end
end
