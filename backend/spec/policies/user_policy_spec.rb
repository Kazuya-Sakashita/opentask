require "rails_helper"

RSpec.describe UserPolicy do
  describe "#show?" do
    let!(:user) { create(:user) }
    let!(:other_user) { create(:user) }
    let!(:admin) { create(:user, role: "admin") }

    context "自分自身の場合" do
      it "許可される" do
        policy = described_class.new(user, user)

        expect(policy.show?).to be true
      end
    end

    context "他人の場合" do
      it "許可されない" do
        policy = described_class.new(user, other_user)

        expect(policy.show?).to be false
      end
    end

    context "管理者の場合" do
      it "許可される" do
        policy = described_class.new(admin, other_user)

        expect(policy.show?).to be true
      end
    end
  end
end
