# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation
  has_secure_password   # password_digest in DB table USERS  https://github.com/rails/rails/blob/master/activemodel/lib/active_model/secure_password.rb
  has_many :microposts, dependent: :destroy

	has_many :relationships, foreign_key: "follower_id", dependent: :destroy
	has_many :followed_users, through: :relationships, source: :followed
	
	has_many :reverse_relationships, foreign_key: "followed_id", 
																	 class_name: "Relationship", 
																	 dependent: :destroy
	has_many :followers, through: :reverse_relationships # source: :follower is not necessary; :followers translates to follower_id automatically

  validates :name, presence: true, length: {maximum: 50}

  VALID_EMAIL_REGEX = /^[\w+\-\.]+@[a-z\d\-\.]+\.[a-z]+$/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false } 
  before_save { self.email.downcase! }
  before_save :create_remember_token

  validates :password, length: {minimum: 6}
  validates :password_confirmation, presence: true

	def feed
    # This is preliminary. See "Following users" for the full implementation.
  	Micropost.from_users_followed_by(self)
	end

	def follow!(other_user)
		relationships.create!(followed_id: other_user.id)
	end

	def following?(other_user)
		relationships.find_by_followed_id(other_user.id)
	end

	def unfollow!(other_user)
		relationships.find_by_followed_id(other_user.id).destroy	
	end

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end

end
