class ListItem < ApplicationRecord
  validates_presence_of :title, :list_id
  belongs_to :list
  has_many :user_checks, dependent: :destroy
end
