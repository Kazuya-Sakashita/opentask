require "rails_helper"

RSpec.describe "Api::V1::Users", type: :request do
  describe "GET /api/v1/users/:userId" do
    let!(:user) { create(:user) }

    context "自分自身の場合" do
      it "ユーザー情報を取得できる" do
        skip
      end
    end

    context "他人の場合" do
      it "403エラーを返す" do
        skip
      end
    end

    context "存在しないユーザーの場合" do
      it "404エラーを返す" do
        skip
      end
    end

    context "管理者の場合" do
      it "ユーザー情報を取得できる" do
        skip
      end
    end
  end
end
