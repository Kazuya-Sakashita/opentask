class ApplicationController < ActionController::API
  include Pundit::Authorization
  include ProblemRenderable

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from Pundit::NotAuthorizedError, with: :render_forbidden
  rescue_from UnauthorizedError, with: :render_unauthorized

  private

  def current_user
    @current_user ||= begin
      payload = Auth::SupabaseJwtVerifier.new(bearer_token).call
      supabase_user_id = payload.fetch("sub")
      email = payload.fetch("email")

      User.find_or_create_by!(supabase_user_id:) do |user|
        user.email = email
        user.name = default_user_name(email)
        user.role = :user
      end
    rescue KeyError, ActiveRecord::RecordInvalid
      raise UnauthorizedError
    end
  end

  def bearer_token
    authorization_header = request.headers["Authorization"]
    scheme, token = authorization_header.to_s.split

    raise UnauthorizedError unless scheme == "Bearer" && token.present?

    token
  end

  def default_user_name(email)
    email.to_s.split("@").first.presence || "User"
  end
end
