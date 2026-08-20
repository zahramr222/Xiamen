
class PackingsController < ApplicationController
  before_action :set_packing, only: %i[show edit update destroy]

  def index
    @packings = Packing
      .includes(:specification)
      .order(created_at: :desc)
  end

  def show
  if params[:id].to_s != @packing.slug.to_s
    redirect_to packing_path(@packing), status: :moved_permanently
  end
end

  def new
    @packing = Packing.new
    @tag_names = ""
  end

  def create
    @packing = Packing.new(packing_params)

    if @packing.save
      save_tags

      redirect_to packings_path, notice: "Packing created successfully."
    else
      @tag_names = params[:tag_names]
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @tag_names = @packing.tags.pluck(:name).join(", ")
  end

  def update
    if @packing.update(packing_params)
      # Remove old tags
      @packing.tags.clear

      # Add new tags
      save_tags

      redirect_to packings_path, notice: "Packing updated successfully."
    else
      @tag_names = params[:tag_names]
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @packing.destroy

    redirect_to packings_path, notice: "Packing deleted successfully."
  end

  private

  def set_packing
  @packing = Packing.friendly.find(params[:id])
  end

  def packing_params
    params.require(:packing).permit(
      :name,
      :slug,
      :content,
      :specification_id,
      :image
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

      @packing.tags << tag unless @packing.tags.include?(tag)
    end
  end
end

