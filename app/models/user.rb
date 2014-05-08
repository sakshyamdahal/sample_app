class User < ActiveRecord::Base
	before_save { self.email = email.downcase }

	validates :name, presence: true, length: { maximum: 50 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
				uniqueness: { case_sensitive: false }
	# validates(:name, presence: true)

	validates :password, length: { minimum: 6 }

	# presence validations for password and its confirmation are automatically
	# added by has_secure_password
	# also adds password and password_confirmation attributes
	# require that they both match
	# add an authenticate method to compare a hashed password to the password_digest
	# to authenticate users
	has_secure_password 

end
