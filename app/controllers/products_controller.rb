  class ProductsController < ApplicationController
    before_action :set_product, only: %i[show edit update destroy]
    before_action :authenticate_user!, only: %i[new create edit update destroy]

    helper ActionView::Helpers::TextHelper

    # --------------------------------------------------
    # Products Index
    # --------------------------------------------------
    def index
  @products = Product.all.order(:name)

  @paraffin_wax = Product.find_by(slug: "paraffin-wax")
  @slack_wax    = Product.find_by(slug: "slack-wax")
  @footsoil     = Product.find_by(slug: "footsoil")
  @base_oil     = Product.find_by(slug: "base-oil")
  @rpo          = Product.find_by(slug: "rpo")

  products_description =
    "Explore Xiamen's range of bitumen and petroleum products, including penetration bitumen, oxidized bitumen, bitumen emulsion, cutback bitumen, base oil, paraffin wax and more."

  set_meta_tags(
    title: "Bitumen & Petroleum Products",
    description: products_description,

    og: {
      title: "Bitumen & Petroleum Products | Xiamen",
      description: products_description,
      type: "website",
      url: "#{request.base_url}#{request.path}",
      site_name: "Xiamen"
    },

    twitter: {
      card: "summary_large_image",
      title: "Bitumen & Petroleum Products | Xiamen",
      description: products_description
    }
  )

  @breadcrumbs = [
    { label: "Products" }
  ]
  end

    # --------------------------------------------------
    # Product Show
    # --------------------------------------------------
    def show
  # Redirect old numeric URLs to the FriendlyId slug URL
  if params[:id].to_s != @product.slug.to_s
    return redirect_to product_path(@product), status: :moved_permanently
  end

  set_record_meta_tags(@product)



  # Get grades for this product
  @grades = @product.grades

  # Related articles
  @articles_data = get_related_articles(@product)

  # Get packings only from grades that belong to this product
  @packings =
  if @grades.any?
    Packing
    .joins(:grade_packings)
    .where(grade_packings: { grade_id: @grades.pluck(:id) })
    .distinct
    .order(:name)
  else
    []
  end

  # Breadcrumbs
  @breadcrumbs = [
    { label: "Products", path: products_path },
    { label: @product.name }
  ]
  end

    # --------------------------------------------------
  # Bitumen Landing Page
  # --------------------------------------------------
  def bitumen
  @oxidized_bitumen =
  Product.find_by(name: "Oxidized Bitumen") ||
  Product.find_by(slug: "oxidized-bitumen")

  @penetration_bitumen =
  Product.find_by(name: "Penetration Bitumen") ||
  Product.find_by(slug: "penetration-bitumen")

  @cutback_bitumen =
  Product.find_by(name: "Cutback Bitumen") ||
  Product.find_by(slug: "cutback-bitumen")

  @emulsion_bitumen =
  Product.find_by(name: "Emulsion Bitumen") ||
  Product.find_by(slug: "emulsion-bitumen")

  @breadcrumbs = [
  { label: "Products", path: products_path },
  { label: "Bitumen" }
  ]

  page_title = "Bitumen Supplier & Exporter"

  page_description =
  "Explore Xiamen's bitumen products, including penetration bitumen, oxidized bitumen, cutback bitumen and bitumen emulsion for road construction, waterproofing and industrial applications."

  page_url = "#{request.base_url}#{request.path}"

  set_meta_tags(
  title: page_title,
  description: page_description,

  og: {
    title: "#{page_title} | Xiamen",
    description: page_description,
    type: "website",
    url: page_url,
    site_name: "Xiamen"
  },

  twitter: {
    card: "summary_large_image",
    title: "#{page_title} | Xiamen",
    description: page_description
  }
  )
  end



    # --------------------------------------------------
    # New
    # --------------------------------------------------
    def new
      @product = Product.new
      @tag_names = ""
    end

    # --------------------------------------------------
    # Create
    # --------------------------------------------------
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

    # --------------------------------------------------
    # Edit
    # --------------------------------------------------
    def edit
      @tag_names = @product.tags.pluck(:name).join(", ")
    end

    # --------------------------------------------------
    # Update
    # --------------------------------------------------
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

    # --------------------------------------------------
    # Destroy
    # --------------------------------------------------
    def destroy
      @product.destroy

      redirect_to products_path,
      notice: "Product was successfully deleted."
    end

    # --------------------------------------------------
    # Private Methods
    # --------------------------------------------------
    private

    # Find product using FriendlyId
    def set_product
      @product = Product.friendly.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      normalized_slug = params[:id].to_s.parameterize

      @product = Product.find_by(slug: normalized_slug)

      if @product
        redirect_to product_path(@product), status: :moved_permanently
      elsif params[:id].to_s.match?(/\A\d+\z/)
        @product = Product.find_by(id: params[:id])

        if @product
          redirect_to product_path(@product), status: :moved_permanently
        else
          raise ActiveRecord::RecordNotFound
        end
      else
        raise ActiveRecord::RecordNotFound
      end
    end

    # Strong Parameters
    def product_params
      params.require(:product).permit(
        :name,
        :content,
        :slug,
        :specification_id,
        :image,
        :meta_title,
        :meta_description,
        grade_ids: []
        )
    end

    # --------------------------------------------------
    # Tags
    # --------------------------------------------------
    def save_tags
      return if params[:tag_names].blank?

      tag_names = params[:tag_names]
      .split(",")
      .map(&:strip)
      .reject(&:blank?)
      .uniq

      tag_names.each do |tag_name|
        tag = Tag
        .where("LOWER(name) = ?", tag_name.downcase)
        .first_or_create!(name: tag_name)

        @product.tags << tag unless @product.tags.exists?(tag.id)
      end
    end

    # --------------------------------------------------
    # Related Articles
    # --------------------------------------------------
    def get_related_articles(product, limit: 3)
      product_tags = product.tags.pluck(:name)

      if product_tags.any?
        related_posts = Post
        .joins(:tags)
        .where(tags: { name: product_tags })
        .group("posts.id")
        .select("posts.*, COUNT(tags.id) as match_count")
        .order("match_count DESC")
        .limit(limit)

        if related_posts.any?
          return related_posts.map do |post|
            summary_text = post.summery || post.content || ""

            if summary_text.length > 120
              summary_text = summary_text[0..119] + "..."
            end

            {
              path: post_path(post),
              image_url: post.image.attached? ?
              url_for(post.image) :
              "https://images.unsplash.com/photo-1494412574643-ff11b0a5c1c3?auto=format&fit=crop&w=900&q=85",
              category: post.post_type || "Article",
              title: post.title,
              summary: summary_text
            }
          end
        end
      end

      # Fallback: latest posts
      Post
      .order(created_at: :desc)
      .limit(limit)
      .map do |post|

        summary_text = post.summery || post.content || ""

        if summary_text.length > 120
          summary_text = summary_text[0..119] + "..."
        end

        {
          path: post_path(post),
          image_url: post.image.attached? ?
          url_for(post.image) :
          "https://images.unsplash.com/photo-1494412574643-ff11b0a5c1c3?auto=format&fit=crop&w=900&q=85",
          category: post.post_type || "Article",
          title: post.title,
          summary: summary_text
        }
      end
    end

    def normalize_slug
      self.slug = slug.to_s.parameterize if slug.present?
    end
    
  end