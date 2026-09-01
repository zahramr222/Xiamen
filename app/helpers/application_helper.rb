module ApplicationHelper
  def related_articles(source, limit: 3, label: "INSIGHTS", title: "Related Articles", description: nil)
    # Get related posts based on source
    related_posts = find_related_posts(source, limit)
    
    # Prepare data for the sidebar
    articles_data = related_posts.map do |post|
      {
        path: post_path(post),
        image_url: post.image.attached? ? url_for(post.image) : "https://images.unsplash.com/photo-1494412574643-ff11b0a5c1c3?auto=format&fit=crop&w=900&q=85",
        category: post.post_type || "Article",
        title: post.title,
        summary: truncate(post.summery || post.content, length: 120)
      }
    end
    
    # If no articles found, use fallback
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
    
    # Render the sidebar partial
    render "shared/right_sidebar",
      label: label,
      title: title,
      description: description || "Latest insights related to this topic.",
      articles: articles_data
  end

  private

  def find_related_posts(source, limit)
    # If source has tags, find posts with same tags
    if source.respond_to?(:tags) && source.tags.any?
      tag_ids = source.tags.pluck(:id)
      
      Post.joins(:tags)
          .where(tags: { id: tag_ids })
          .where.not(id: source.id) if source.respond_to?(:id)
          .group("posts.id")
          .select("posts.*, COUNT(tags.id) as match_count")
          .order("match_count DESC")
          .limit(limit)
    else
      # If source has no tags, get latest posts
      Post.limit(limit).order(created_at: :desc)
    end
  rescue
    # If anything fails, return empty array
    []
  end
end