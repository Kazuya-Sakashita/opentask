class UserSerializer
  def self.call(user)
    {
      public_id: user.public_id,
      email: user.email,
      name: user.name,
      role: user.role
    }
  end
end
