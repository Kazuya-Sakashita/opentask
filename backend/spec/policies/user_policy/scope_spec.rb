require "rails_helper"

RSpec.describe UserPolicy::Scope do
  describe "#resolve" do
    let!(:user) { create(:user) }
    let!(:other_user) { create(:user) }
    let!(:admin) { create(:user, role: "admin") }

    context "一般ユーザーの場合" do
      it "自分自身のみ取得できる" do
        scope = described_class.new(user, User.all)

        result = scope.resolve

        expect(result).to contain_exactly(user)
      end
    end

    context "管理者の場合" do
      it "全ユーザーを取得できる" do
        scope = described_class.new(admin, User.all)

        result = scope.resolve

        expect(result).to contain_exactly(user, other_user, admin)
      end
    end
  end
end
