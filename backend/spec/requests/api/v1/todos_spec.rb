require "rails_helper"

RSpec.describe "Api::V1::Todos", type: :request do
  describe "GET /api/v1/todos" do
    let!(:user) { create(:user) }
    let!(:other_user) { create(:user) }
    let!(:todo) { create(:todo, user:) }

    before do
      create(:todo, user: other_user)
    end

    context "ログインしている場合" do
      it "ログインユーザーのTodo一覧を取得できる" do
        get "/api/v1/todos", headers: auth_headers(user)

        expect(response).to have_http_status(:ok)

        assert_response_schema_confirm(200)

        body = response.parsed_body

        expect(body).to contain_exactly(
          include(
            "public_id" => todo.public_id,
            "title" => todo.title,
            "description" => todo.description,
            "completed" => todo.completed
          )
        )
      end
    end

    context "未ログインの場合" do
      before do
        get "/api/v1/todos"
      end

      it_behaves_like "unauthorized response"
    end
  end

  describe "GET /api/v1/todos/:todoId" do
    let!(:user) { create(:user) }

    context "自分のTodoの場合" do
      let!(:todo) { create(:todo, user:) }

      it "Todo詳細を取得できる" do
        get "/api/v1/todos/#{todo.public_id}", headers: auth_headers(user)

        expect(response).to have_http_status(:ok)

        assert_response_schema_confirm(200)

        body = response.parsed_body

        expect(body).to include(
          "public_id" => todo.public_id,
          "title" => todo.title,
          "description" => todo.description,
          "completed" => todo.completed
        )
      end
    end

    context "存在しないTodoの場合" do
      before do
        get "/api/v1/todos/not-found-id", headers: auth_headers(user)
      end

      it_behaves_like "not found response"
    end

    context "他人のTodoの場合" do
      let!(:other_user) { create(:user) }
      let!(:todo) { create(:todo, user: other_user) }

      before do
        get "/api/v1/todos/#{todo.public_id}", headers: auth_headers(user)
      end

      it_behaves_like "forbidden response"
    end
  end

  describe "POST /api/v1/todos" do
    let!(:user) { create(:user) }

    context "有効なパラメータの場合" do
      let!(:valid_params) do
        {
          todo: {
            title: "新しいTodo",
            description: "Todoの説明",
            completed: false
          }
        }
      end

      before do
        post "/api/v1/todos",
             params: valid_params,
             headers: auth_headers(user)
      end

      it "Todoを作成できる" do
        expect(Todo.count).to eq(1)
        expect(response).to have_http_status(:created)

        assert_response_schema_confirm(201)
      end

      it "作成したTodoを返す" do
        body = response.parsed_body

        expect(body["public_id"]).to be_present
        expect(body["title"]).to eq("新しいTodo")
        expect(body["description"]).to eq("Todoの説明")
        expect(body["completed"]).to be false
      end
    end

    context "titleが空のとき" do
      before do
        post "/api/v1/todos",
             params: {
               todo: {
                 title: ""
               }
             },
             headers: auth_headers(user)
      end

      it_behaves_like "validation error response"
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
              headers: auth_headers(user)

        expect(response).to have_http_status(:ok)

        assert_response_schema_confirm(200)

        todo.reload

        expect(todo.title).to eq("更新後のTodo")
        expect(todo.completed).to be true
      end
    end

    context "titleが空のとき" do
      let!(:todo) { create(:todo, user:) }

      before do
        patch "/api/v1/todos/#{todo.public_id}",
              params: {
                todo: {
                  title: ""
                }
              },
              headers: auth_headers(user)
      end

      it_behaves_like "validation error response"
    end

    context "存在しないTodoの場合" do
      before do
        patch "/api/v1/todos/not-found-id",
              params: {
                todo: {
                  title: "更新後のTodo"
                }
              },
              headers: auth_headers(user)
      end

      it_behaves_like "not found response"
    end

    context "他人のTodoの場合" do
      let!(:other_user) { create(:user) }
      let!(:todo) { create(:todo, user: other_user) }

      before do
        patch "/api/v1/todos/#{todo.public_id}",
              params: {
                todo: {
                  title: "更新後のTodo"
                }
              },
              headers: auth_headers(user)
      end

      it_behaves_like "forbidden response"
    end
  end

  describe "DELETE /api/v1/todos/:todoId" do
    let!(:user) { create(:user) }

    context "自分のTodoの場合" do
      let!(:todo) { create(:todo, user:) }

      it "Todoを論理削除できる" do
        delete "/api/v1/todos/#{todo.public_id}", headers: auth_headers(user)

        expect(response).to have_http_status(:no_content)

        assert_response_schema_confirm(204)

        expect(todo.reload.deleted_at).to be_present
      end
    end

    context "存在しないTodoの場合" do
      before do
        delete "/api/v1/todos/not-found-id", headers: auth_headers(user)
      end

      it_behaves_like "not found response"
    end

    context "他人のTodoの場合" do
      let!(:other_user) { create(:user) }
      let!(:todo) { create(:todo, user: other_user) }

      before do
        delete "/api/v1/todos/#{todo.public_id}", headers: auth_headers(user)
      end

      it_behaves_like "forbidden response"
    end
  end
end
