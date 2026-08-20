class Packing < ApplicationRecord
  extend FriendlyId

  friendly_id :slug, use: :slugged

  belongs_to :specification, optional: true

  has_many :grade_packings
  has_many :grades, through: :grade_packings

  has_many :packing_tags, dependent: :destroy
  has_many :tags, through: :packing_tags

  has_one_attached :image
end