require "rails_helper"

RSpec.describe "Api::V1::Todos", type: :request do
  describe "GET /api/v1/todos" do
    let!(:user) { create(:user) }
    let!(:other_user) { create(:user) }
    let!(:todo) { create(:todo, user:) }
    let!(:other_todo) { create(:todo, user: other_user) }

    context "ログインしている場合" do
      it "ログインユーザーのTodo一覧を取得できる" do
        get "/api/v1/todos", headers: authenticate_as(user)

        expect(response).to have_http_status(:ok)

        assert_response_schema_confirm(200)

        body = response.parsed_body

        expect(body.length).to eq 1
        expect(body.first["public_id"]).to eq todo.public_id
        expect(body.first["public_id"]).not_to eq other_todo.public_id
      end
    end

    context "未ログインの場合" do
      it "401エラーを返す" do
        get "/api/v1/todos"

        expect(response).to have_http_status(:unauthorized)

        assert_response_schema_confirm(401)

        body = response.parsed_body

        expect(body["title"]).to eq("Unauthorized")
        expect(body["reason"]).to eq("unauthorized")
        expect(body["status"]).to eq(401)
      end
    end
  end

  describe "GET /api/v1/todos/:todoId" do
    let!(:user) { create(:user) }

    context "存在しないTodoの場合" do
      it "404エラーを返す" do
        get "/api/v1/todos/not-found-id", headers: authenticate_as(user)

        expect(response).to have_http_status(:not_found)

        assert_response_schema_confirm(404)

        body = response.parsed_body

        expect(body["title"]).to eq("Not Found")
        expect(body["reason"]).to eq("not_found")
        expect(body["status"]).to eq(404)
      end
    end

    context "他人のTodoの場合" do
      let!(:other_user) { create(:user) }
      let!(:todo) { create(:todo, user: other_user) }

      it "403エラーを返す" do
        get "/api/v1/todos/#{todo.public_id}", headers: authenticate_as(user)

        expect(response).to have_http_status(:forbidden)

        assert_response_schema_confirm(403)

        body = response.parsed_body

        expect(body["title"]).to eq("Forbidden")
        expect(body["reason"]).to eq("forbidden")
        expect(body["status"]).to eq(403)
      end
    end
  end

  describe "POST /api/v1/todos" do
    let!(:user) { create(:user) }

    context "titleが空のとき" do
      it "422エラーを返す" do
        post "/api/v1/todos",
             params: {
               todo: {
                 title: ""
               }
             },
             headers: authenticate_as(user)

        expect(response).to have_http_status(:unprocessable_content)

        assert_response_schema_confirm(422)

        body = response.parsed_body

        expect(body["title"]).to eq("Validation Error")
        expect(body["reason"]).to eq("validation_error")
        expect(body["status"]).to eq(422)
        expect(body["errors"]).to have_key("title")
      end
    end
  end

  describe "PATCH /api/v1/todos/:todoId" do
    let!(:user) { create(:user) }

    context "自分のTodoの場合" do
      let!(:todo) { create(:todo, user:) }

      it "Todoを更新できる" do
        patch "/api/v1/todos/#{todo.public_id}",
              params: {
                todo: {
                  title: "更新後のTodo",
                  completed: true
                }
              },
              headers: authenticate_as(user)

        expect(response).to have_http_status(:ok)

        assert_response_schema_confirm(200)

        body = response.parsed_body

        expect(body["public_id"]).to eq(todo.public_id)
        expect(body["title"]).to eq("更新後のTodo")
        expect(body["completed"]).to be true
      end
    end

    context "titleが空のとき" do
      let!(:todo) { create(:todo, user:) }

      it "422エラーを返す" do
        patch "/api/v1/todos/#{todo.public_id}",
              params: {
                todo: {
                  title: ""
                }
              },
              headers: authenticate_as(user)

        expect(response).to have_http_status(:unprocessable_content)

        assert_response_schema_confirm(422)

        body = response.parsed_body

        expect(body["title"]).to eq("Validation Error")
        expect(body["reason"]).to eq("validation_error")
        expect(body["status"]).to eq(422)
        expect(body["errors"]).to have_key("title")
      end
    end

    context "存在しないTodoの場合" do
      it "404エラーを返す" do
        patch "/api/v1/todos/not-found-id",
              params: {
                todo: {
                  title: "更新後のTodo"
                }
              },
              headers: authenticate_as(user)

        expect(response).to have_http_status(:not_found)

        assert_response_schema_confirm(404)
      end
    end

    context "他人のTodoの場合" do
      let!(:other_user) { create(:user) }
      let!(:todo) { create(:todo, user: other_user) }

      it "403エラーを返す" do
        patch "/api/v1/todos/#{todo.public_id}",
              params: {
                todo: {
                  title: "更新後のTodo"
                }
              },
              headers: authenticate_as(user)

        expect(response).to have_http_status(:forbidden)

        assert_response_schema_confirm(403)
      end
    end
  end

  describe "DELETE /api/v1/todos/:todoId" do
    let!(:user) { create(:user) }

    context "自分のTodoの場合" do
      let!(:todo) { create(:todo, user:) }

      it "Todoを論理削除できる" do
        delete "/api/v1/todos/#{todo.public_id}", headers: authenticate_as(user)

        expect(response).to have_http_status(:no_content)

        assert_response_schema_confirm(204)

        expect(todo.reload.deleted_at).to be_present
      end
    end

    context "存在しないTodoの場合" do
      it "404エラーを返す" do
        delete "/api/v1/todos/not-found-id", headers: authenticate_as(user)

        expect(response).to have_http_status(:not_found)

        assert_response_schema_confirm(404)
      end
    end

    context "他人のTodoの場合" do
      let!(:other_user) { create(:user) }
      let!(:todo) { create(:todo, user: other_user) }

      it "403エラーを返す" do
        delete "/api/v1/todos/#{todo.public_id}", headers: authenticate_as(user)

        expect(response).to have_http_status(:forbidden)

        assert_response_schema_confirm(403)
      end
    end
  end
end
