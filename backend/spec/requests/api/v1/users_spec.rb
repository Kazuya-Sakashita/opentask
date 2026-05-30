require "rails_helper"

RSpec.describe "Api::V1::Users", type: :request do
  describe "GET /api/v1/users/:userId" do
    let!(:user) { create(:user) }

    context "自分自身の場合" do
      it "ユーザー情報を取得できる" do
        get "/api/v1/users/#{user.public_id}", headers: auth_headers(user)

        expect(response).to have_http_status(:ok)

        assert_response_schema_confirm(200)

        body = response.parsed_body

        expect(body).to include(
          "public_id" => user.public_id,
          "email" => user.email,
          "name" => user.name,
          "role" => user.role
        )
      end
    end

    context "他人の場合" do
      let!(:other_user) { create(:user) }

      before do
        get "/api/v1/users/#{other_user.public_id}", headers: auth_headers(user)
      end

      it_behaves_like "forbidden response"
    end

    context "存在しないユーザーの場合" do
      before do
        get "/api/v1/users/not-found-id", headers: auth_headers(user)
      end

      it_behaves_like "not found response"
    end

    context "管理者の場合" do
      let!(:admin) { create(:user, role: "admin") }
      let!(:other_user) { create(:user) }

      it "ユーザー情報を取得できる" do
        get "/api/v1/users/#{other_user.public_id}", headers: auth_headers(admin)

        expect(response).to have_http_status(:ok)

        assert_response_schema_confirm(200)

        body = response.parsed_body

        expect(body).to include(
          "public_id" => other_user.public_id,
          "email" => other_user.email,
          "name" => other_user.name,
          "role" => other_user.role
        )
      end
    end
  end
end
