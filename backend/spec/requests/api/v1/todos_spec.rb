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

      assert_response_schema_confirm(200)

      body = response.parsed_body

      expect(body.length).to eq 1
      expect(body.first["public_id"]).to eq todo.public_id
      expect(body.first["public_id"]).not_to eq other_todo.public_id
    end
  end

  describe "GET /api/v1/todos/:todoId" do
    let!(:user) { create(:user) }

    before do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    end

    context "存在しないTodoの場合" do
      it "404エラーを返す" do
        get "/api/v1/todos/not-found-id"

        expect(response).to have_http_status(:not_found)

        body = response.parsed_body

        expect(body["title"]).to eq("Not Found")
        expect(body["reason"]).to eq("not_found")
        expect(body["status"]).to eq(404)
      end
    end
  end

  describe "POST /api/v1/todos" do
    let!(:user) { create(:user) }

    before do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    end

    context "titleが空のとき" do
      it "422エラーを返す" do
        post "/api/v1/todos",
             params: {
               todo: {
                 title: ""
               }
             }

        expect(response).to have_http_status(:unprocessable_content)

        body = response.parsed_body

        expect(body["title"]).to eq("Validation Error")
        expect(body["reason"]).to eq("validation_error")
        expect(body["status"]).to eq(422)
        expect(body["errors"]).to have_key("title")
      end
    end
  end
end
