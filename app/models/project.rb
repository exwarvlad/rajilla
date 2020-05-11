class Project < ApplicationRecord
  has_many :tasks

  validates :name, presence: true
  validates :price, presence: true
end
