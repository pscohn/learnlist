class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  validates :username, presence: true, length: { maximum: 50 },
                       uniqueness: { case_sensitive: false }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :description, length: { maximum: 100 }

  attr_accessor :activation_token

  has_secure_password

  has_many :lists
  has_many :list_users
  has_many :user_checks

  before_save { self.email = email.downcase }
  before_create :create_activation_digest

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def to_param
    username
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

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

  def percent_completed(list)
    item_ids = list.list_items.pluck(:id)
    return 0 if item_ids.blank?
    completed_ids = user_checks.where(list_item_id: item_ids, completed: true).pluck(:list_item_id)
    completed_ids.count.to_f / item_ids.count * 100
  end

  def check_completion(list)
    item_ids = list.list_items.pluck(:id)
    completed_ids = user_checks.where(list_item_id: item_ids, completed: true).pluck(:list_item_id)
    list_completed = item_ids.sort == completed_ids.sort
    list_user = list_users.find_or_create_by(list: list)
    if list_completed
      list_user.update_attributes(state: 'completed')
    elsif completed_ids.count > 0 && list_user.state != 'in_progress'
      list_user.update_attributes(state: 'in_progress')
    end
    list_completed
  end

  def next_item(list)
    list_state = list_users.find_by(list: list)&.state
    #return nil if list_state != 'in_progress'
    list_items = list.list_items
    checks = user_checks.where(completed: true, list_item_id: list_items.pluck(:id)).pluck(:list_item_id)
    next_item = list.list_items.where.not(id: checks).order(id: :asc).limit(1).take
    return next_item
  end

  private
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
