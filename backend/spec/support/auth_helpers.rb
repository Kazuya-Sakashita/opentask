module AuthHelpers
  def authenticate_as(user)
    verifier = instance_double(Auth::SupabaseJwtVerifier)

    allow(Auth::SupabaseJwtVerifier)
      .to receive(:new)
      .with("test-token")
      .and_return(verifier)

    allow(verifier)
      .to receive(:call)
      .and_return({ "sub" => user.supabase_user_id })

    {
      "Authorization" => "Bearer test-token"
    }
  end
end

RSpec.configure do |config|
  config.include AuthHelpers, type: :request
end
