require "rails_helper"

RSpec.describe TodoSerializer do
  describe ".call" do
    let!(:todo) { create(:todo) }

    it "Todo情報をHashで返す" do
      result = described_class.call(todo)

      expect(result).to eq(
        {
          public_id: todo.public_id,
          title: todo.title,
          description: todo.description,
          completed: todo.completed,
          created_at: todo.created_at.iso8601,
          updated_at: todo.updated_at.iso8601
        }
      )
    end
  end
end
