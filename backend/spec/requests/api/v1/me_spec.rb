require "rails_helper"

RSpec.describe "Api::V1::Me", type: :request do
  describe "GET /api/v1/me" do
    context "認証済みの場合" do
      let!(:user) { create(:user, supabase_user_id: "supabase-user-id") }

      before do
        get "/api/v1/me", headers: auth_headers(user)
      end

      it "現在のユーザー情報を取得できる" do
        expect(response).to have_http_status(:ok)

        assert_response_schema_confirm(200)
      end

      it "現在のユーザー情報を返す" do
        body = response.parsed_body

        expect(body.keys).to contain_exactly(
          "public_id",
          "email",
          "name",
          "role"
        )

        expect(body).to include(
          "public_id" => user.public_id,
          "email" => user.email,
          "name" => user.name,
          "role" => user.role
        )
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
