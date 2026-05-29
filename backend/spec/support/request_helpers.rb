module RequestHelpers
  def auth_headers(user)
    authenticate_as(user)
  end
end

RSpec.configure do |config|
  config.include RequestHelpers, type: :request
end
