require "rails_helper"

RSpec.describe "Api::V1::Users", type: :request do
  describe "GET /api/v1/users" do
    let!(:user) { create(:user) }
    let!(:other_user) { create(:user) }

    context "一般ユーザーの場合" do
      it "自分自身のみ取得できる" do
        get "/api/v1/users", headers: auth_headers(user)

        expect(response).to have_http_status(:ok)

        assert_response_schema_confirm(200)

        body = response.parsed_body

        expect(body).to contain_exactly(
          include(
            "public_id" => user.public_id,
            "email" => user.email,
            "name" => user.name,
            "role" => user.role
          )
        )
      end
    end

    context "未認証の場合" do
      before do
        get "/api/v1/users"
      end

      it_behaves_like "unauthorized response"
    end

    context "管理者の場合" do
      let!(:admin) { create(:user, role: "admin") }

      it "全ユーザーを取得できる" do
        get "/api/v1/users", headers: auth_headers(admin)

        expect(response).to have_http_status(:ok)

        assert_response_schema_confirm(200)

        body = response.parsed_body

        expect(body).to contain_exactly(
          include("public_id" => user.public_id),
          include("public_id" => other_user.public_id),
          include("public_id" => admin.public_id)
        )
      end
    end
  end

  describe "GET /api/v1/users/:userId" do
    let!(:user) { create(:user) }

    context "自分自身の場合" do
      before do
        get "/api/v1/users/#{user.public_id}", headers: auth_headers(user)
      end

      it "ユーザー情報を取得できる" do
        expect(response).to have_http_status(:ok)

        assert_response_schema_confirm(200)
      end

      it "ユーザー情報を返す" do
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
        get "/api/v1/users/#{user.public_id}"
      end

      it_behaves_like "unauthorized response"
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

      before do
        get "/api/v1/users/#{other_user.public_id}", headers: auth_headers(admin)
      end

      it "ユーザー情報を取得できる" do
        expect(response).to have_http_status(:ok)

        assert_response_schema_confirm(200)
      end

      it "ユーザー情報を返す" do
        body = response.parsed_body

        expect(body.keys).to contain_exactly(
          "public_id",
          "email",
          "name",
          "role"
        )

        expect(body).to include(
          "public_id" => other_user.public_id,
          "email" => other_user.email,
          "name" => other_user.name,
          "role" => other_user.role
        )
      end
    end
  end

  describe "PATCH /api/v1/users/:userId" do
    let!(:user) { create(:user) }

    context "自分自身の場合" do
      let!(:valid_params) do
        {
          user: {
            name: "更新後ユーザー"
          }
        }
      end

      before do
        patch "/api/v1/users/#{user.public_id}",
              params: valid_params,
              headers: auth_headers(user)
      end

      it "ユーザー情報を更新できる" do
        user.reload

        expect(user.name).to eq("更新後ユーザー")
        expect(response).to have_http_status(:ok)

        assert_response_schema_confirm(200)
      end

      it "更新後のユーザー情報を返す" do
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
          "name" => "更新後ユーザー",
          "role" => user.role
        )
      end
    end

    context "roleを指定した場合" do
      before do
        patch "/api/v1/users/#{user.public_id}",
              params: {
                user: {
                  name: "更新後ユーザー",
                  role: "admin"
                }
              },
              headers: auth_headers(user)
      end

      it "roleは更新されない" do
        user.reload

        expect(user.name).to eq("更新後ユーザー")
        expect(user.role).to eq("user")
        expect(response).to have_http_status(:ok)

        assert_response_schema_confirm(200)
      end
    end

    context "nameが空の場合" do
      before do
        patch "/api/v1/users/#{user.public_id}",
              params: {
                user: {
                  name: ""
                }
              },
              headers: auth_headers(user)
      end

      it_behaves_like "validation error response", "name"
    end

    context "未認証の場合" do
      before do
        patch "/api/v1/users/#{user.public_id}",
              params: {
                user: {
                  name: "更新後ユーザー"
                }
              }
      end

      it_behaves_like "unauthorized response"
    end

    context "他人の場合" do
      let!(:other_user) { create(:user) }

      before do
        patch "/api/v1/users/#{other_user.public_id}",
              params: {
                user: {
                  name: "更新後ユーザー"
                }
              },
              headers: auth_headers(user)
      end

      it_behaves_like "forbidden response"
    end

    context "存在しないユーザーの場合" do
      before do
        patch "/api/v1/users/not-found-id",
              params: {
                user: {
                  name: "更新後ユーザー"
                }
              },
              headers: auth_headers(user)
      end

      it_behaves_like "not found response"
    end

    context "管理者の場合" do
      let!(:admin) { create(:user, role: "admin") }
      let!(:other_user) { create(:user) }

      before do
        patch "/api/v1/users/#{other_user.public_id}",
              params: {
                user: {
                  name: "管理者による更新"
                }
              },
              headers: auth_headers(admin)
      end

      it "他人のユーザー情報を更新できる" do
        other_user.reload

        expect(other_user.name).to eq("管理者による更新")
        expect(response).to have_http_status(:ok)

        assert_response_schema_confirm(200)
      end

      it "更新後のユーザー情報を返す" do
        body = response.parsed_body

        expect(body.keys).to contain_exactly(
          "public_id",
          "email",
          "name",
          "role"
        )

        expect(body).to include(
          "public_id" => other_user.public_id,
          "email" => other_user.email,
          "name" => "管理者による更新",
          "role" => other_user.role
        )
      end
    end
  end
end
