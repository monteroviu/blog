class Category < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :has_categories
  has_many :articles, through: :has_categories
end
