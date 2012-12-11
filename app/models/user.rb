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

  validates :name, presence: true, length: {maximum: 50}

  VALID_EMAIL_REGEX = /^[\w+\-\.]+@[a-z\d\-\.]+\.[a-z]+$/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false } 
  before_save { self.email.downcase! }
  before_save :create_remember_token

  validates :password, length: {maximum: 6}
  validates :password_confirmation, presence: true

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end

end
