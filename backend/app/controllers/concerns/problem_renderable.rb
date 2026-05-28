module ProblemRenderable
  extend ActiveSupport::Concern

  private

  def render_problem(type:, title:, status:, detail:, reason:, errors: nil)
    body = {
      type: type,
      title: title,
      status: Rack::Utils.status_code(status),
      detail: detail,
      reason: reason
    }

    body[:errors] = errors if errors.present?

    render json: body, status: status, content_type: "application/problem+json"
  end

  def render_validation_error(record)
    render_problem(
      type: "https://opentask.example.com/problems/validation-error",
      title: "Validation Error",
      status: :unprocessable_content,
      detail: "入力内容に誤りがあります",
      reason: "validation_error",
      errors: record.errors.to_hash
    )
  end

  def render_not_found
    render_problem(
      type: "https://opentask.example.com/problems/not-found",
      title: "Not Found",
      status: :not_found,
      detail: "指定されたリソースが見つかりません",
      reason: "not_found"
    )
  end

  def render_forbidden
    render_problem(
      type: "https://opentask.example.com/problems/forbidden",
      title: "Forbidden",
      status: :forbidden,
      detail: "この操作を実行する権限がありません",
      reason: "forbidden"
    )
  end

  def render_unauthorized
    render_problem(
      type: "https://opentask.example.com/problems/unauthorized",
      title: "Unauthorized",
      status: :unauthorized,
      detail: "認証が必要です",
      reason: "unauthorized"
    )
  end
end
