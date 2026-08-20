class ProductsController < ApplicationController
  before_action :set_product, only: %i[show edit update destroy]
  
  # REMOVE THIS LINE:
  # layout "product"

  def index
    @products = Product.all
  end

  def show
    
    # Permanently redirect old numeric URLs to the slug URL
    if params[:id].to_s != @product.slug.to_s
    redirect_to product_path(@product), status: :moved_permanently
  end
  end
  

  # Bitumen Landing Page
  def bitumen
    @sub_products = [
      { name: "Oxidized Bitumen", 
        path: products_oxidized_bitumen_path, 
        description: "High-quality oxidized bitumen for industrial applications.",
        icon: "fa-solid fa-fire" },
      { name: "Penetration Bitumen", 
        path: products_penetration_bitumen_path, 
        description: "Standard penetration grade bitumen for road construction.",
        icon: "fa-solid fa-road" },
      { name: "Cutback Bitumen", 
        path: products_cutback_bitumen_path, 
        description: "Bitumen dissolved in solvent for cold application.",
        icon: "fa-solid fa-droplet" },
      { name: "Emulsion Bitumen", 
        path: products_emulsion_bitumen_path, 
        description: "Bitumen emulsion for surface dressing and maintenance.",
        icon: "fa-solid fa-water" }
    ]
    
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
end