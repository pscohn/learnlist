class User < ApplicationRecord
  before_save { self.email = email.downcase }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :username, presence: true, length: { maximum: 50 },
                       uniqueness: { case_sensitive: false }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  has_many :lists
  has_many :list_users
  has_many :user_checks

  def to_param
    username
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
    list_user = list_users.find_by(list: list)
    if list_completed
      list_user.update_attributes(state: 'completed')
    elsif completed_ids.count > 0 && list_user.state != 'in_progress'
      list_user.update_attributes(state: 'in_progress')
    end
    list_completed
  end
end
