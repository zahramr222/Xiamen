class Packing < ApplicationRecord
  extend FriendlyId

  friendly_id :slug, use: :slugged
  before_validation :normalize_slug

  belongs_to :specification, optional: true

  has_many :grade_packings
  has_many :grades, through: :grade_packings

  has_many :packing_tags, dependent: :destroy
  has_many :tags, through: :packing_tags

  has_one_attached :image

  private

  def normalize_slug
    self.slug =
      if slug.present?
        slug.to_s.parameterize
      elsif name.present?
        name.to_s.parameterize
      end
  end
end