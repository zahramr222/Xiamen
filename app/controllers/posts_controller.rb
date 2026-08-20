class PostsController < ApplicationController
  before_action :set_post, only: %i[
    show
    edit
    update
    destroy
  ]

  def index
    @posts = Post.all.order(created_at: :desc)
    
    @reports = Post.where(post_type: ["Reports", "report", "reports"]).order(created_at: :desc).limit(4)
    @articles = Post.where(post_type: ["Articles", "article", "articles"]).order(created_at: :desc).limit(4)
    @news = Post.where(post_type: ["News", "news"]).order(created_at: :desc).limit(4)
    @applications = Post.where(post_type: ["Applications", "application", "applications"]).order(created_at: :desc).limit(4)

    @products = Product.limit(6).order(created_at: :desc)
    
    @breadcrumbs = [
      { label: "Posts" }
    ]
  end

  def show
    if params[:id].to_s != @post.slug.to_s
      redirect_to post_path(@post), status: :moved_permanently
    end
    
    @related_posts = Post.where(post_type: @post.post_type)
                         .where.not(id: @post.id)
                         .limit(3)
    
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
end