class User < ActiveRecord::Base
	has_many :lists
	has_secure_password

	def slug
		self.username.gsub(" ","-").downcase
	end

	def self.find_by_slug(slug)
		@username = slug.split('-').join(" ")
		self.find_by(username: @username)
	end
end