class Post < ApplicationRecord
has_many :post_tags, dependent: :destroy
has_many :tags, through: :post_tags

has_one_attached :image


  POST_TYPES = [
    "News",
    "Articles",
    "Applications",
    "Reports"
  ].freeze


extend FriendlyId
friendly_id :slug, use: :slugged  



validates :title, :slug, :post_type, presence: true
validates :post_type, inclusion: { in: POST_TYPES }, inclusion: { in: ["News", "Articles", "Applications", "Reports"] }



  scope :reports, -> { where(post_type: "Reports") }
  scope :articles, -> {where(post_type: ["Articles", "Applications"])}

end