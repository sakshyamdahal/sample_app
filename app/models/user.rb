class User < ActiveRecord::Base
	has_many :microposts, dependent: :destroy # destroys micropost when user is destroyed
	has_many :relationships, foreign_key: "follower_id", dependent: :destroy
	has_many :followed_users, through: :relationships, source: :followed
	has_many :reverse_relationships, foreign_key: "followed_id", class_name: "Relationship", 
													dependent: :destroy
	has_many :followers, through: :reverse_relationships, source: :follower

	before_save { self.email = email.downcase }
	before_create :create_remember_token
	# before_save { email.downcase! }

	validates :name, presence: true, length: { maximum: 50 }

	# a valid email regex
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
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

	def User.new_remember_token
		SecureRandom.urlsafe_base64
	end

	def User.digest(token)
		Digest::SHA1.hexdigest(token.to_s)
	end

	def feed
    	Micropost.from_users_followed_by(self)
  	end

  	def following?(other_user)
  		self.relationships.find_by(followed_id: other_user.id)
  	end

  	def follow!(other_user)
  		relationships.create!(followed_id: other_user.id)
  	end

  	def unfollow!(other_user)
  		relationships.find_by(followed_id: other_user.id).destroy
  	end


	private
		def create_remember_token
			self.remember_token = User.digest(User.new_remember_token)
		end

end
