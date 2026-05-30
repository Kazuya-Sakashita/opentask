require "rails_helper"

RSpec.describe "Api::V1::Me", type: :request do
  describe "GET /api/v1/me" do
    context "認証済みの場合" do
      let!(:user) { create(:user, supabase_user_id: "supabase-user-id") }

      it "現在のユーザー情報を取得できる" do
        get "/api/v1/me", headers: auth_headers(user)

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
      before do
        get "/api/v1/me"
      end

      it_behaves_like "unauthorized response"
    end
  end
end
