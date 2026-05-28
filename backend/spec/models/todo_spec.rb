require "rails_helper"

RSpec.describe Todo, type: :model do
  describe "validations" do
    let!(:todo) { build(:todo) }

    it "有効なファクトリを持つ" do
      expect(todo).to be_valid
    end

    it "public_idが自動生成される" do
      todo.save!

      expect(todo.public_id).to be_present
    end

    it "titleが必須である" do
      todo.title = nil

      expect(todo).not_to be_valid
    end
  end

  describe ".active" do
    let!(:active_todo) { create(:todo) }
    let!(:deleted_todo) { create(:todo, :deleted) }

    it "deleted_atがnilのTodoのみ返す" do
      expect(described_class.active).to include(active_todo)
      expect(described_class.active).not_to include(deleted_todo)
    end
  end

  describe "#soft_delete!" do
    let!(:todo) { create(:todo) }

    it "deleted_atを設定する" do
      todo.soft_delete!

      expect(todo.deleted_at).to be_present
    end
  end
end
