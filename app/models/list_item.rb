class ListItem < ApplicationRecord
  belongs_to :list
  has_many :user_checks, dependent: :destroy
end
