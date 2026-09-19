  class PackingsController < ApplicationController
    before_action :set_packing, only: %i[show edit update destroy]
    before_action :authenticate_user!, only: %i[new create edit update destroy]

    def index
      packings_scope = Packing
      .includes(:grades, :tags)
      .order(created_at: :desc)

      @pagy, @packings = pagy(
        packings_scope,
        limit: 9
        )

      page_title = "Packing Solutions"

      page_description =
      "Explore Global Synergy's available packing solutions for bitumen and petroleum products, including options for safe handling, storage and international transportation."

      page_url = "#{request.base_url}#{request.path}"

      set_meta_tags(
        title: page_title,
        description: page_description,

        og: {
          title: "#{page_title} | Global Synergy",
          description: page_description,
          type: "website",
          url: page_url,
          site_name: "Global Synergy"
        },

        twitter: {
          card: "summary_large_image",
          title: "#{page_title} | Global Synergy",
          description: page_description
        }
        )

      @breadcrumbs = [
        { label: "Packings" }
      ]
    end

    def show
      if params[:id].to_s != @packing.slug.to_s
        return redirect_to packing_path(@packing), status: :moved_permanently
      end

      set_record_meta_tags(@packing)

      @grades = @packing.grades.includes(:product)

      @products = @grades
      .map(&:product)
      .compact
      .uniq

      @specification = @packing.specification

      @breadcrumbs = [
        { label: "Packings", path: packings_path },
        { label: @packing.name }
      ]
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
  rescue ActiveRecord::RecordNotFound
    normalized_slug = params[:id].to_s.parameterize

    @packing = Packing.find_by(slug: normalized_slug)

    if @packing
      redirect_to packing_path(@packing), status: :moved_permanently
    elsif params[:id].to_s.match?(/\A\d+\z/)
      @packing = Packing.find_by(id: params[:id])

      if @packing
        redirect_to packing_path(@packing), status: :moved_permanently
      else
        raise ActiveRecord::RecordNotFound
      end
    else
      raise ActiveRecord::RecordNotFound
    end
  end

    def packing_params
      params.require(:packing).permit(
        :name,
        :slug,
        :content,
        :image,
        grade_ids: []  # Changed from :specification_id to :grade_ids (has_many through)
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

    def normalize_slug
    self.slug = slug.to_s.parameterize if slug.present?
    end
  end