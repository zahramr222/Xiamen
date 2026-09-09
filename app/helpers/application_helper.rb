module ApplicationHelper

  def default_meta_tags
    {
      site: "Xiamen",
      reverse: true,

      title: "Global Bitumen Supplier & Exporter",

      description: "Xiamen is a global bitumen supplier and exporter providing premium bitumen, petroleum products and industrial materials with reliable worldwide shipping and competitive pricing.",

      canonical: canonical_url,

      og: {
        title: "Global Bitumen Supplier & Exporter | Xiamen",
        description: "Xiamen is a global bitumen supplier and exporter providing premium bitumen, petroleum products and industrial materials with reliable worldwide shipping and competitive pricing.",
        type: "website",
        url: canonical_url,
        site_name: "Xiamen"
      },

      twitter: {
        card: "summary_large_image",
        title: "Global Bitumen Supplier & Exporter | Xiamen",
        description: "Xiamen is a global bitumen supplier and exporter providing premium bitumen, petroleum products and industrial materials with reliable worldwide shipping and competitive pricing."
      }
    }
  end

  def canonical_url
    "#{request.base_url}#{request.path}"
  end

  def related_articles(
    source,
    limit: 3,
    label: "INSIGHTS",
    title: "Related Articles",
    description: nil
  )
    related_posts = find_related_posts(source, limit)

    articles_data = related_posts.map do |post|
      {
        path: post_path(post),

        image_url:
          if post.image.attached?
            url_for(post.image)
          else
            "https://images.unsplash.com/photo-1494412574643-ff11b0a5c1c3?auto=format&fit=crop&w=900&q=85"
          end,

        category: post.post_type || "Article",

        title: post.title,

        summary: truncate(
          post.summery || post.content,
          length: 120
        )
      }
    end

    if articles_data.empty?
      articles_data = [
        {
          path: "#",
          image_url: "https://images.unsplash.com/photo-1494412574643-ff11b0a5c1c3?auto=format&fit=crop&w=900&q=85",
          category: "Market",
          title: "Global Bitumen Market Developments",
          summary: "Latest pricing, supply conditions and international shipping movements."
        },

        {
          path: "#",
          image_url: "https://images.unsplash.com/photo-1504917595217-d4dc5ebe6122?auto=format&fit=crop&w=900&q=85",
          category: "Supply",
          title: "Understanding Bitumen Supply Chains",
          summary: "Key factors affecting bitumen availability and international trade."
        }
      ]
    end

    render(
      "shared/right_sidebar",
      label: label,
      title: title,
      description: description || "Latest insights related to this topic.",
      articles: articles_data
    )
  end

  


  private

  def find_related_posts(source, limit)
    if source.respond_to?(:tags) && source.tags.any?
      tag_ids = source.tags.pluck(:id)

      scope = Post.joins(:tags)
                  .where(tags: { id: tag_ids })

      scope = scope.where.not(id: source.id) if source.respond_to?(:id)

      scope
        .group("posts.id")
        .select("posts.*, COUNT(tags.id) AS match_count")
        .order("match_count DESC")
        .limit(limit)
    else
      Post
        .order(created_at: :desc)
        .limit(limit)
    end
  rescue StandardError
    []
  end
end

