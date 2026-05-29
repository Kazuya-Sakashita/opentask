require "rails_helper"

RSpec.describe "Api::V1::Me", type: :request do
  describe "GET /api/v1/me" do
    context "認証済みの場合" do
      let!(:user) { create(:user, supabase_user_id: "supabase-user-id") }

      before do
        verifier = instance_double(Auth::SupabaseJwtVerifier)

        allow(Auth::SupabaseJwtVerifier)
          .to receive(:new)
          .with("valid-token")
          .and_return(verifier)

        allow(verifier)
          .to receive(:call)
          .and_return({ "sub" => user.supabase_user_id })
      end

      it "現在のユーザー情報を取得できる" do
        get "/api/v1/me",
            headers: {
              "Authorization" => "Bearer valid-token"
            }

        expect(response).to have_http_status(:ok)

        assert_response_schema_confirm(200)

        body = response.parsed_body

        expect(body["public_id"]).to eq(user.public_id)
        expect(body["email"]).to eq(user.email)
        expect(body["name"]).to eq(user.name)
        expect(body["role"]).to eq(user.role)
      end
    end

    context "未認証の場合" do
      it "401エラーを返す" do
        get "/api/v1/me"

        expect(response).to have_http_status(:unauthorized)

        assert_response_schema_confirm(401)

        body = response.parsed_body

        expect(body["title"]).to eq("Unauthorized")
        expect(body["reason"]).to eq("unauthorized")
        expect(body["status"]).to eq(401)
      end
    end
  end
end
