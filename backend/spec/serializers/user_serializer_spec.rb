require "rails_helper"

RSpec.describe UserSerializer do
  describe ".call" do
    let!(:user) { create(:user) }

    it "ユーザー情報をHashで返す" do
      result = described_class.call(user)

      expect(result).to eq(
        {
          public_id: user.public_id,
          email: user.email,
          name: user.name,
          role: user.role
        }
      )
    end
  end
end
