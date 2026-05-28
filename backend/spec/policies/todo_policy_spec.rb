require "rails_helper"

RSpec.describe TodoPolicy do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:admin) { create(:user, :admin) }
  let!(:todo) { create(:todo, user:) }

  describe "#show?" do
    context "自分のTodoの場合" do
      it "許可される" do
        expect(described_class.new(user, todo).show?).to be true
      end
    end

    context "他人のTodoの場合" do
      it "許可されない" do
        expect(described_class.new(other_user, todo).show?).to be false
      end
    end

    context "管理者の場合" do
      it "許可される" do
        expect(described_class.new(admin, todo).show?).to be true
      end
    end
  end
end
