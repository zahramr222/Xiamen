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
before_validation :normalize_slug


validates :title, :slug, :post_type, presence: true
validates :post_type, inclusion: { in: POST_TYPES }



  scope :reports, -> { where(post_type: "Reports") }
  scope :articles, -> {where(post_type: ["Articles", "Applications"])}

  # Scopes for related posts
  scope :by_category, ->(category) { where(post_type: category) }
  scope :except_post, ->(post) { where.not(id: post) }
  scope :latest, ->(limit) { order(created_at: :desc).limit(limit) }

  # Method to get related posts
  def related_posts(limit: 3)
    RelatedPostsService.new(self, limit: limit).call
  end

end