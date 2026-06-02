module AuthHelpers
  def authenticate_as(user, token: "test-token")
    verifier = instance_double(Auth::SupabaseJwtVerifier)

    allow(Auth::SupabaseJwtVerifier)
      .to receive(:new)
      .with(token)
      .and_return(verifier)

    allow(verifier)
      .to receive(:call)
      .and_return(
        {
          "sub" => user.supabase_user_id,
          "email" => user.email
        }
      )

    {
      "Authorization" => "Bearer #{token}"
    }
  end
end

RSpec.configure do |config|
  config.include AuthHelpers, type: :request
end
