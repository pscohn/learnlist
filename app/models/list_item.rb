class ListItem < ApplicationRecord
  validates_presence_of :list_id
  validate :title_or_link
  belongs_to :list
  has_many :user_checks, dependent: :destroy

  default_scope { order(:index) }

  private

  def title_or_link
    if !link && !title
      errors.add(:base, 'Add a title or link')
    end
  end
end
