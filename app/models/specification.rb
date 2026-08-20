class Specification < ApplicationRecord
  has_many :packings
  has_many :grades
  has_many :products
  belongs_to :grade, optional: true

end