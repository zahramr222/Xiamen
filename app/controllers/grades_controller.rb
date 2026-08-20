class GradesController < ApplicationController
  before_action :set_grade, only: %i[show edit update destroy]

  def index
    @grades = Grade.all
  end

  def show
    # Permanently redirect old numeric URLs to the slug URL
    if params[:id].to_s != @grade.slug.to_s
      redirect_to grade_path(@grade), status: :moved_permanently
    end
    
    # Get the product this grade belongs to
    @product = @grade.product
    
    # Set related articles to empty array to avoid nil errors
    @related_articles = []
  end

  def new
    @grade = Grade.new
    @tag_names = ""
  end

  def create
    @grade = Grade.new(grade_params)

    if @grade.save
      save_tags
      redirect_to @grade, notice: "Grade created successfully."
    else
      @tag_names = params[:tag_names]
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @tag_names = @grade.tags.pluck(:name).join(", ")
  end

  def update
    if @grade.update(grade_params)
      # Remove old tags
      @grade.tags.clear

      # Add new tags
      save_tags

      redirect_to @grade, notice: "Grade updated successfully."
    else
      @tag_names = params[:tag_names]
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @grade.destroy
    redirect_to grades_path, notice: "Grade deleted successfully."
  end

  private

  def set_grade
    @grade = Grade.friendly.find(params[:id])
  end

  def grade_params
    params.require(:grade).permit(
      :name,
      :slug,
      :content,
      :image,
      :product_id,        # Add this for the new relationship
      packing_ids: []
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

      @grade.tags << tag unless @grade.tags.include?(tag)
    end
  end
end