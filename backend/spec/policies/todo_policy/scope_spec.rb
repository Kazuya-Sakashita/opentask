require "rails_helper"

RSpec.describe TodoPolicy::Scope do
  describe "#resolve" do
    let!(:user) { create(:user) }
    let!(:other_user) { create(:user) }
    let!(:admin) { create(:user, role: "admin") }

    let!(:user_todo) { create(:todo, user:) }
    let!(:other_todo) { create(:todo, user: other_user) }
    let!(:deleted_todo) { create(:todo, user:, deleted_at: Time.current) }

    context "一般ユーザーの場合" do
      it "自分の未削除Todoのみ取得できる" do
        scope = described_class.new(user, Todo.all)

        result = scope.resolve

        expect(result).to contain_exactly(user_todo)
        expect(result).not_to include(deleted_todo)
      end
    end

    context "管理者の場合" do
      it "全ユーザーの未削除Todoを取得できる" do
        scope = described_class.new(admin, Todo.all)

        result = scope.resolve

        expect(result).to contain_exactly(user_todo, other_todo)
        expect(result).not_to include(deleted_todo)
      end
    end
  end
end
