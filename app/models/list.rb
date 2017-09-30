class List < ApplicationRecord
  validates :name, presence: true
  validates :user_id, presence: true
  validates :description, length: { maximum: 200 }

  belongs_to :user
  has_many :list_items, dependent: :destroy
  has_many :list_users, dependent: :destroy
  default_scope -> { order(created_at: :desc) }

  accepts_nested_attributes_for :list_items, allow_destroy: true

  def update_saves
    update_attributes(saves: list_users.where(saved: true).count)
  end
end
