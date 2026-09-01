class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy]
  before_action :authenticate_user!, only: %i[new create edit update destroy]

  def index
    @posts = Post.all.order(created_at: :desc)
    
    @reports = Post.where(post_type: ["Reports", "report", "reports"]).order(created_at: :desc).limit(4)
    @articles = Post.where(post_type: ["Articles", "article", "articles"]).order(created_at: :desc).limit(4)
    @news = Post.where(post_type: ["News", "news"]).order(created_at: :desc).limit(4)
    @applications = Post.where(post_type: ["Applications", "application", "applications"]).order(created_at: :desc).limit(4)
    
    @breadcrumbs = [{ label: "Posts" }]
  end

  def show
    if params[:id].to_s != @post.slug.to_s
      redirect_to post_path(@post), status: :moved_permanently
    end
    
    # Get related posts based on tags, title, and summary
    @related_posts = find_related_posts(@post)
    
    @breadcrumbs = [
      { label: "Posts", path: posts_path },
      { label: @post.title }
    ]
  end

  def new
    @post = Post.new
    @tag_names = ""
  end

  def edit
    @tag_names = @post.tags.pluck(:name).join(", ")
  end

  def create
    @post = Post.new(post_params)

    if @post.save
      save_tags
      redirect_to @post, notice: "Post created successfully."
    else
      @tag_names = params[:tag_names]
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @post.update(post_params)
      @post.tags.clear
      save_tags
      redirect_to @post, notice: "Post updated successfully."
    else
      @tag_names = params[:tag_names]
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: "Post deleted successfully."
  end

  private

  def set_post
    @post = Post.friendly.find(params[:id])
  end

  def post_params
    params.require(:post).permit(
      :title,
      :slug,
      :content,
      :post_type,
      :image,
      :summery
    )
  end

  def save_tags
    return if params[:tag_names].blank?

    tag_names = params[:tag_names]
                  .split(",")
                  .map(&:strip)
                  .reject(&:blank?)
                  .uniq

    tag_names.each do |tag_name|
      tag = Tag.where("LOWER(name) = ?", tag_name.downcase)
               .first_or_create!(name: tag_name)
      @post.tags << tag unless @post.tags.exists?(tag.id)
    end
  end

  def find_related_posts(post, limit: 3)
    # Get all posts except current
    all_posts = Post.where.not(id: post.id)

    # Get current post's tags
    post_tags = post.tags.pluck(:name).map(&:downcase)
    post_words = post.title.downcase.split + (post.summery || "").downcase.split

    # Calculate relevance score for each post
    scored_posts = all_posts.map do |other_post|
      score = 0
      
      # 1. Tag match (highest weight)
      other_tags = other_post.tags.pluck(:name).map(&:downcase)
      matching_tags = (post_tags & other_tags).count
      score += matching_tags * 10

      # 2. Same category/post_type
      if other_post.post_type == post.post_type
        score += 5
      end

      # 3. Title word match
      other_title_words = other_post.title.downcase.split
      matching_title_words = (post_words & other_title_words).count
      score += matching_title_words * 3

      # 4. Summary word match
      if other_post.summery.present?
        other_summary_words = other_post.summery.downcase.split
        matching_summary_words = (post_words & other_summary_words).count
        score += matching_summary_words * 2
      end

      {
        post: other_post,
        score: score,
        matching_tags: matching_tags
      }
    end

    # Sort by score (highest first) and get top posts
    scored_posts.sort_by { |item| -item[:score] }
                .reject { |item| item[:score] == 0 }
                .first(limit)
                .map { |item| item[:post] }
  end
end