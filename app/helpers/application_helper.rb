module ApplicationHelper

  # =====================================================
  # DEFAULT META TAGS
  # =====================================================

  def default_meta_tags
    {
      site: "Global Synergy",
      reverse: true,

      title: "Bitumen Supplier & Petroleum Products Exporter",

      description: "Global Synergy is a reliable bitumen supplier and petroleum products exporter offering high-quality bitumen, slack wax, paraffin wax and other industrial products at competitive prices.",

      canonical: canonical_url,

      og: {
        title: "Bitumen Supplier & Petroleum Products Exporter | Global Synergy",
        description: "Global Synergy supplies high-quality bitumen, slack wax, paraffin wax and petroleum products for international markets with reliable export services and competitive prices.",
        type: "website",
        url: canonical_url,
        site_name: "Global Synergy"
      },

      twitter: {
        card: "summary_large_image",
        title: "Bitumen Supplier & Petroleum Products Exporter | Global Synergy",
        description: "Global Synergy supplies high-quality bitumen, slack wax, paraffin wax and petroleum products for international markets with reliable export services and competitive prices."
      }
    }
  end


  # =====================================================
  # CANONICAL URL
  # =====================================================

  def canonical_url
    "#{request.base_url}#{request.path}"
  end


  # =====================================================
  # STRUCTURED DATA - ORGANIZATION
  # =====================================================

  def organization_schema
    {
      "@context": "https://schema.org",
      "@type": "Organization",
      "name": "Global Synergy",
      "url": request.base_url
    }
  end


  # =====================================================
  # STRUCTURED DATA - WEBSITE
  # =====================================================

  def website_schema
    {
      "@context": "https://schema.org",
      "@type": "WebSite",
      "name": "Global Synergy",
      "url": request.base_url
    }
  end


  # =====================================================
  # RELATED ARTICLES
  # =====================================================

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
          strip_tags(
            post.summery.presence || post.content.to_s
            ),
          length: 120
          )
      }
    end


    if articles_data.empty?
  random_posts = Post.order(Arel.sql("RANDOM()")).limit(3)

  articles_data = random_posts.map do |post|
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
        strip_tags(
          post.summery.presence || post.content.to_s
        ),
        length: 120
      )
    }
  end
end

    render(
      "shared/right_sidebar",
      label: label,
      title: title,
      description: description || "Latest insights related to this topic.",
      articles: articles_data
    )
  end

  def breadcrumb_schema(breadcrumbs)
    return nil if breadcrumbs.blank?

    items = [
      {
        "@type": "ListItem",
        "position": 1,
        "name": "Home",
        "item": root_url
      }
    ]

    breadcrumbs.each_with_index do |crumb, index|
      item = {
        "@type": "ListItem",
        "position": index + 2,
        "name": crumb[:label].to_s
      }

      item["item"] =
      if crumb[:path].present?
        URI.join(request.base_url, crumb[:path]).to_s
      else
        canonical_url
      end

      items << item
    end

    {
      "@context": "https://schema.org",
      "@type": "BreadcrumbList",
      "itemListElement": items
    }
  end

  def product_schema(product)
    description =
      if product.meta_description.present?
        product.meta_description
      elsif product.content.present?
        strip_tags(product.content).squish.truncate(300)
      else
        "Explore #{product.name} supplied by Global Synergy for international markets."
      end

    image_url =
      if product.respond_to?(:image) && product.image.attached?
        url_for(product.image)
      end

    if image_url.present? && image_url.start_with?("/")
      image_url = "#{request.base_url}#{image_url}"
    end

    {
      "@context": "https://schema.org",
      "@type": "Product",
      "name": product.name,
      "description": description,
      "url": product_url(product),
      "image": image_url
    }.compact
  end

  def post_schema(post)
    description =
    if post.meta_description.present?
      post.meta_description
    elsif post.summery.present?
      strip_tags(post.summery).squish.truncate(300)
    elsif post.content.present?
      strip_tags(post.content).squish.truncate(300)
    else
      "Read #{post.title} on Global Synergy."
    end

    image_url =
    if post.image.attached?
      url_for(post.image)
    end

    if image_url.present? && image_url.start_with?("/")
      image_url = "#{request.base_url}#{image_url}"
    end

    {
      "@context": "https://schema.org",
      "@type": post_schema_type(post),
      "headline": post.title,
      "description": description,
      "url": post_url(post),
      "datePublished": post.created_at.iso8601,
      "dateModified": post.updated_at.iso8601,
      "image": image_url,
      "publisher": {
      "@type": "Organization",
      "name": "Global Synergy",
      "url": request.base_url
    }
    }.compact
  end


  def post_schema_type(post)
    case post.post_type
    when "News"
      "NewsArticle"
    when "Reports", "Report"
      "Report"
    else
      "Article"
    end
  end


  private

  def find_related_posts(source, limit)
    return Post.none unless source.respond_to?(:tags)

    tag_ids = source.tags.pluck(:id)

    return Post.none if tag_ids.empty?

    Post
      .joins(:tags)
      .where(tags: { id: tag_ids })
      .select(
        "posts.*",
        "COUNT(DISTINCT tags.id) AS matching_tags_count"
      )
      .group("posts.id")
      .order(
        Arel.sql("matching_tags_count DESC"),
        created_at: :desc
      )
      .limit(limit)
  end

  def safe_content_html(content)
  sanitize(
    content,
    tags: %w[
      p br
      strong b em i u
      ul ol li
      h2 h3 h4 h5
      a
      blockquote
      table thead tbody tr th td
      span div
    ],
    attributes: %w[
      href
      title
      target
      rel
      class
    ]
  )
end

end