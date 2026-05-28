require "rails_helper"

RSpec.describe "Api::V1::Todos", type: :request do
  describe "GET /api/v1/todos" do
    let!(:user) { create(:user) }
    let!(:other_user) { create(:user) }
    let!(:todo) { create(:todo, user:) }
    let!(:other_todo) { create(:todo, user: other_user) }

    before do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    end

    it "ログインユーザーのTodo一覧を取得できる" do
      get "/api/v1/todos"

      expect(response).to have_http_status(:ok)

      body = response.parsed_body

      expect(body.length).to eq 1
      expect(body.first["public_id"]).to eq todo.public_id
      expect(body.first["public_id"]).not_to eq other_todo.public_id
    end
  end
end
