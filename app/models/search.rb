class Search
  include Rails.application.routes.url_helpers

  MINIMUM_QUERY_LENGTH = 3
  MAX_RESULTS = 20

  def initialize(query)
    @query = query.to_s.strip
  end

  def call
    return [] if query.length < MINIMUM_QUERY_LENGTH

    results = []

    results.concat(search_by_tags)
    results.concat(search_products)
    results.concat(search_grades)
    results.concat(search_packings)
    results.concat(search_posts)

    remove_duplicates(results)
      .sort_by { |result| -result[:score] }
      .first(MAX_RESULTS)
  end

  private

  attr_reader :query

  def search_by_tags
    results = []

    Tag.where("name ILIKE ?", "%#{ActiveRecord::Base.sanitize_sql_like(query)}%").find_each do |tag|
      tag.products.find_each do |product|
        results << {
          type: "Product", id: product.id, title: product.name,
          url: product_path(product), matched_by: "tag", score: 1000,
          image: image_url_for(product)
        }
      end
      tag.grades.find_each do |grade|
        results << {
          type: "Grade", id: grade.id, title: grade.name,
          url: grade_path(grade), matched_by: "tag", score: 1000,
          image: image_url_for(grade)
        }
      end
      tag.packings.find_each do |packing|
        results << {
          type: "Packing", id: packing.id, title: packing.name,
          url: packing_path(packing), matched_by: "tag", score: 1000,
          image: image_url_for(packing)
        }
      end
      tag.posts.find_each do |post|
        results << {
          type: "Post", id: post.id, title: post.title,
          url: post_path(post), matched_by: "tag", score: 1000,
          image: image_url_for(post)
        }
      end
    end

    results
  end

  def search_products
    term = "%#{ActiveRecord::Base.sanitize_sql_like(query)}%"
    Product.where("name ILIKE :term OR content ILIKE :term", term: term).find_each.map do |product|
      if product.name.to_s.downcase.include?(query.downcase)
        score = 500; matched_by = "name"
      else
        score = 100; matched_by = "content"
      end
      {
        type: "Product", id: product.id, title: product.name,
        url: product_path(product), matched_by: matched_by, score: score,
        image: image_url_for(product)
      }
    end
  end

  def search_grades
    term = "%#{ActiveRecord::Base.sanitize_sql_like(query)}%"
    Grade.where("name ILIKE :term OR content ILIKE :term", term: term).find_each.map do |grade|
      if grade.name.to_s.downcase.include?(query.downcase)
        score = 500; matched_by = "name"
      else
        score = 100; matched_by = "content"
      end
      {
        type: "Grade", id: grade.id, title: grade.name,
        url: grade_path(grade), matched_by: matched_by, score: score,
        image: image_url_for(grade)
      }
    end
  end

  def search_packings
    term = "%#{ActiveRecord::Base.sanitize_sql_like(query)}%"
    Packing.where("name ILIKE :term OR content ILIKE :term", term: term).find_each.map do |packing|
      if packing.name.to_s.downcase.include?(query.downcase)
        score = 500; matched_by = "name"
      else
        score = 100; matched_by = "content"
      end
      {
        type: "Packing", id: packing.id, title: packing.name,
        url: packing_path(packing), matched_by: matched_by, score: score,
        image: image_url_for(packing)
      }
    end
  end

  def search_posts
    term = "%#{ActiveRecord::Base.sanitize_sql_like(query)}%"
    Post.where("title ILIKE :term OR content ILIKE :term", term: term).find_each.map do |post|
      if post.title.to_s.downcase.include?(query.downcase)
        score = 500; matched_by = "title"
      else
        score = 100; matched_by = "content"
      end
      {
        type: "Post", id: post.id, title: post.title,
        url: post_path(post), matched_by: matched_by, score: score,
        image: image_url_for(post)
      }
    end
  end

  def remove_duplicates(results)
    results
      .group_by { |result| [result[:type], result[:id]] }
      .values
      .map { |matches| matches.max_by { |result| result[:score] } }
  end

  def image_url_for(record)
    if record.respond_to?(:image) && record.image.attached?
      rails_blob_path(record.image, only_path: true)
    else
      nil
    end
  end
end