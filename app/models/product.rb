class Product < ApplicationRecord
  extend FriendlyId
  friendly_id :slug, use: :slugged
  

  has_many :grades, dependent: :nullify

  belongs_to :specification, optional: true
  
  has_many :product_tags, dependent: :destroy
  has_many :tags, through: :product_tags

  has_one_attached :image
end