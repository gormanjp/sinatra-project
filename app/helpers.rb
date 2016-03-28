class Helpers
  def self.current_user(user)
  	@user = User.find_by_id(user[:id])
  	@user
  end

  def self.is_logged_in?(user)
  	!!self.current_user(user)
  end

end