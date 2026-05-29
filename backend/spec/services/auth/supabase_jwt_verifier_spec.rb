require "rails_helper"

RSpec.describe Auth::SupabaseJwtVerifier do
  describe "#call" do
    subject(:verifier) { described_class.new(token) }

    let!(:token) { "dummy-token" }

    context "JWTの検証に成功する場合" do
      it "payloadを返す" do
        payload = {
          "sub" => "supabase-user-id"
        }

        allow(JWT).to receive(:decode)
          .and_return([ payload, {} ])

        expect(verifier.call).to eq(payload)
      end
    end

    context "JWTの検証に失敗する場合" do
      it "UnauthorizedErrorを発生させる" do
        allow(JWT).to receive(:decode)
          .and_raise(JWT::DecodeError)

        expect do
          verifier.call
        end.to raise_error(UnauthorizedError)
      end
    end
  end
end
