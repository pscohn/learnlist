class ListItem < ApplicationRecord
  validates_presence_of :list_id
  validate :title_or_link
  belongs_to :list
  has_many :user_checks, dependent: :destroy
  before_save do |item|
    unless item.index
    end
  end

  default_scope { order(:index) }

  def title_or_link
    if title.blank? && link.blank?
      errors.add(:title, 'or link must be present')
    end
  end
end
