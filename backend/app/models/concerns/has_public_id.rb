module HasPublicId
  extend ActiveSupport::Concern

  included do
    before_validation :set_public_id, on: :create
  end

  private

  def set_public_id
    self.public_id ||= SecureRandom.base58(26)
  end
end
