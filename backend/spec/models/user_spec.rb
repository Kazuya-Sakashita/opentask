require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    let!(:user) { build(:user) }

    it "有効なファクトリを持つ" do
      expect(user).to be_valid
    end

    it "public_idが自動生成される" do
      user.save!

      expect(user.public_id).to be_present
    end

    it "supabase_user_idが必須である" do
      user.supabase_user_id = nil

      expect(user).not_to be_valid
    end
  end
end
