class Todo < ApplicationRecord
  include HasPublicId

  belongs_to :user

  scope :active, -> { where(deleted_at: nil) }

  validates :public_id, presence: true, uniqueness: true
  validates :title, presence: true

  def soft_delete!
    update!(deleted_at: Time.current)
  end
end
