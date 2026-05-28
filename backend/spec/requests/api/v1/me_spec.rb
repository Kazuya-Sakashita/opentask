require "rails_helper"

RSpec.describe "Api::V1::Mes", type: :request do
  describe "GET /api/v1/me" do
    let!(:user) { create(:user) }

    before do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    end

    it "現在のユーザー情報を取得できる" do
      get "/api/v1/me"

      expect(response).to have_http_status(:ok)

      body = response.parsed_body

      expect(body["public_id"]).to eq user.public_id
      expect(body["email"]).to eq user.email
      expect(body["name"]).to eq user.name
    end
  end
end
