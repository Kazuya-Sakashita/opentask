class User < ApplicationRecord
  include HasPublicId

  enum :role, { user: 0, admin: 1 }

  has_many :todos, dependent: :restrict_with_exception

  validates :public_id, presence: true, uniqueness: true
  validates :supabase_user_id, presence: true, uniqueness: true
  validates :email, presence: true
  validates :name, presence: true
end
