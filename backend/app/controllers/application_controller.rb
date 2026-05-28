class ApplicationController < ActionController::API
  include Pundit::Authorization
  include ProblemRenderable

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from Pundit::NotAuthorizedError, with: :render_forbidden
  rescue_from UnauthorizedError, with: :render_unauthorized

  private

  def current_user
    user = User.first

    raise UnauthorizedError if user.blank?

    user
  end
end
