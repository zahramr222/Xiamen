class ProductsController < ApplicationController
  before_action :set_product, only: %i[show edit update destroy]
  before_action :authenticate_user!, only: %i[new create edit update destroy]
  helper ActionView::Helpers::TextHelper 

  def index
    @products = Product.all
  end

  def show
    # Permanently redirect old numeric URLs to the slug URL
    if params[:id].to_s != @product.slug.to_s
      redirect_to product_path(@product), status: :moved_permanently
    end
    
    # Get grades for this product
    @grades = @product.grades

    @articles_data = get_related_articles(@product)

    # ✅ Get packings ONLY from grades that belong to this product
    @packings = if @grades.any?
      Packing.joins(:grade_packings)
             .where(grade_packings: { grade_id: @grades.pluck(:id) })
             .distinct
             .order(:name)
    else
      []
    end
    
    @breadcrumbs = [
      { label: "Products", path: products_path },
      { label: @product.name }
    ]
  end

  # Bitumen Landing Page
  def bitumen
    # Find the actual products (not the landing page)
    @oxidized_bitumen = Product.find_by(name: "Oxidized Bitumen") || Product.find_by(slug: "oxidized-bitumen")
    @penetration_bitumen = Product.find_by(name: "Penetration Bitumen") || Product.find_by(slug: "penetration-bitumen")
    @cutback_bitumen = Product.find_by(name: "Cutback Bitumen") || Product.find_by(slug: "cutback-bitumen")
    @emulsion_bitumen = Product.find_by(name: "Emulsion Bitumen") || Product.find_by(slug: "emulsion-bitumen")
    
    @breadcrumbs = [
      { label: "Products", path: products_path },
      { label: "Bitumen" }
    ]
  end

  # Paraffin Wax Page
  def paraffin_wax
    @breadcrumbs = [
      { label: "Products", path: products_path },
      { label: "Paraffin Wax" }
    ]
  end

  # Slack Wax Page
  def slack_wax
    @breadcrumbs = [
      { label: "Products", path: products_path },
      { label: "Slack Wax" }
    ]
  end

  # Footsoil Page
  def footsoil
    @breadcrumbs = [
      { label: "Products", path: products_path },
      { label: "Footsoil" }
    ]
  end

  # Base Oil Page
  def base_oil
    @breadcrumbs = [
      { label: "Products", path: products_path },
      { label: "Base Oil" }
    ]
  end

  # RPO Page
  def rpo
    @breadcrumbs = [
      { label: "Products", path: products_path },
      { label: "RPO" }
    ]
  end

  # Bitumen Sub-product Pages
  def oxidized_bitumen
    @product = Product.find_by(name: "Oxidized Bitumen") || Product.new(name: "Oxidized Bitumen")
    @breadcrumbs = [
      { label: "Products", path: products_path },
      { label: "Bitumen", path: products_bitumen_path },
      { label: "Oxidized Bitumen" }
    ]
    render "bitumen_sub_product"
  end

  def penetration_bitumen
    @product = Product.find_by(name: "Penetration Bitumen") || Product.new(name: "Penetration Bitumen")
    @breadcrumbs = [
      { label: "Products", path: products_path },
      { label: "Bitumen", path: products_bitumen_path },
      { label: "Penetration Bitumen" }
    ]
    render "bitumen_sub_product"
  end

  def cutback_bitumen
    @product = Product.find_by(name: "Cutback Bitumen") || Product.new(name: "Cutback Bitumen")
    @breadcrumbs = [
      { label: "Products", path: products_path },
      { label: "Bitumen", path: products_bitumen_path },
      { label: "Cutback Bitumen" }
    ]
    render "bitumen_sub_product"
  end

  def emulsion_bitumen
    @product = Product.find_by(name: "Emulsion Bitumen") || Product.new(name: "Emulsion Bitumen")
    @breadcrumbs = [
      { label: "Products", path: products_path },
      { label: "Bitumen", path: products_bitumen_path },
      { label: "Emulsion Bitumen" }
    ]
    render "bitumen_sub_product"
  end

  def new
    @product = Product.new
    @tag_names = ""
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      save_tags
      redirect_to @product, notice: "Product was successfully created."
    else
      @tag_names = params[:tag_names]
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @tag_names = @product.tags.pluck(:name).join(", ")
  end

  def update
    if @product.update(product_params)
      # Remove old tags
      @product.tags.clear
      # Add new tags
      save_tags
      redirect_to @product, notice: "Product was successfully updated."
    else
      @tag_names = params[:tag_names]
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    redirect_to products_path, notice: "Product was successfully deleted."
  end

  private

  def set_product
    @product = Product.friendly.find(params[:id])
  end

  def product_params
    params.require(:product).permit(
      :name,
      :content,
      :slug,
      :specification_id,
      :image,
      grade_ids: []
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
      @product.tags << tag unless @product.tags.exists?(tag.id)
    end
  end

  def get_related_articles(product, limit: 3)
    # Get product tags
    product_tags = product.tags.pluck(:name)
    
    if product_tags.any?
      # Find posts with same tags
      related_posts = Post.joins(:tags)
                          .where(tags: { name: product_tags })
                          .group("posts.id")
                          .select("posts.*, COUNT(tags.id) as match_count")
                          .order("match_count DESC")
                          .limit(limit)
      
      if related_posts.any?
        return related_posts.map do |post|
          summary_text = post.summery || post.content || ""
          summary_text = summary_text[0..119] + "..." if summary_text.length > 120
          
          {
            path: post_path(post),
            image_url: post.image.attached? ? url_for(post.image) : "https://images.unsplash.com/photo-1494412574643-ff11b0a5c1c3?auto=format&fit=crop&w=900&q=85",
            category: post.post_type || "Article",
            title: post.title,
            summary: summary_text
          }
        end
      end
    end
    
    # Fallback: Get latest posts
    Post.limit(limit).order(created_at: :desc).map do |post|
      summary_text = post.summery || post.content || ""
      summary_text = summary_text[0..119] + "..." if summary_text.length > 120
      
      {
        path: post_path(post),
        image_url: post.image.attached? ? url_for(post.image) : "https://images.unsplash.com/photo-1494412574643-ff11b0a5c1c3?auto=format&fit=crop&w=900&q=85",
        category: post.post_type || "Article",
        title: post.title,
        summary: summary_text
      }
    end
  end
end