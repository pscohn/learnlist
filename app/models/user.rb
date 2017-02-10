class User < ApplicationRecord
  before_save { self.email = email.downcase }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :username, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  has_many :lists
  has_many :list_users
  has_many :user_checks

  def saved?(list)
    list_user = list_users.find_by(list: list)
    list_user && list_user.saved == true
  end

  def in_progress?(list)
    list_user = list_users.find_by(list: list)
    list_user && list_user.state == 'in_progress'
  end

  def completed?(list)
    list_user = list_users.find_by(list: list)
    list_user && list_user.state == 'completed'
  end

  def checked?(item)
    user_check = user_checks.find_by(list_item: item)
    user_check && user_check.completed == true
  end
end
