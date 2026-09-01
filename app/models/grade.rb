class Grade < ApplicationRecord
  extend FriendlyId
  friendly_id :slug, use: :slugged

  has_many :specifications, dependent: :nullify

  has_many :grade_packings
  has_many :packings, through: :grade_packings

  belongs_to :product, optional: true


  has_many :grade_tags, dependent: :destroy
  has_many :tags, through: :grade_tags

  has_one_attached :image
  has_one_attached :msds_file 
end