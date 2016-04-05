class Helpers
  def self.current_user(user)
  	@user = User.find_by_id(user[:id])
  	@user
  end

  def self.is_logged_in?(user)
  	!!self.current_user(user)
  end

  def self.user_match(list,session)
  	list.user_id == session[:id]
  end

end