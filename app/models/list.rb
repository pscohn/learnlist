class List < ApplicationRecord
  validates :name, presence: true
  has_many :list_items, dependent: :destroy
  accepts_nested_attributes_for :list_items, reject_if: lambda { |fields| fields[:title].blank? }
end
