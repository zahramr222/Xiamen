class Tag < ApplicationRecord

  has_many :post_tags, dependent: :destroy
  has_many :posts, through: :post_tags

  has_many :product_tags, dependent: :destroy
  has_many :products, through: :product_tags

  has_many :grade_tags, dependent: :destroy
  has_many :grades, through: :grade_tags

  has_many :packing_tags, dependent: :destroy
  has_many :packings, through: :packing_tags

  validates :name, presence: true, uniqueness: true
end