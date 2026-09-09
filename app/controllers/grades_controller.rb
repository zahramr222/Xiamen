  class GradesController < ApplicationController
    before_action :set_grade, only: %i[show edit update destroy]
    before_action :authenticate_user!, only: %i[new create edit update destroy]

    def index
      @grades = Grade.all.order(:name)

      grades_description =
      "Explore Xiamen's available bitumen grades, specifications, packing options and industrial applications for international supply and export."

      set_meta_tags(
        title: "Bitumen Grades & Specifications",
        description: grades_description,

        og: {
          title: "Bitumen Grades & Specifications | Xiamen",
          description: grades_description,
          type: "website",
          url: "#{request.base_url}#{request.path}",
          site_name: "Xiamen"
        },

        twitter: {
          card: "summary_large_image",
          title: "Bitumen Grades & Specifications | Xiamen",
          description: grades_description
        }
        )

      @breadcrumbs = [
        { label: "Grades" }
      ]
    end

    def show
      if params[:id].to_s != @grade.slug.to_s
        redirect_to grade_path(@grade), status: :moved_permanently
      end
      set_record_meta_tags(@grade)
      
      @product = @grade.product
      @articles_data = get_related_articles(@grade)
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
        @grade.tags.clear
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
    rescue ActiveRecord::RecordNotFound
      normalized_slug = params[:id].to_s.parameterize

      @grade = Grade.find_by(slug: normalized_slug)

      if @grade
        redirect_to grade_path(@grade), status: :moved_permanently
      elsif params[:id].to_s.match?(/\A\d+\z/)
        @grade = Grade.find_by(id: params[:id])

        if @grade
          redirect_to grade_path(@grade), status: :moved_permanently
        else
          raise ActiveRecord::RecordNotFound
        end
      else
        raise ActiveRecord::RecordNotFound
      end
    end

    def grade_params
      params.require(:grade).permit(
        :name,
        :slug,
        :content,
        :image,
        :msds_file,
        :product_id,
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

    def get_related_articles(grade, limit: 3)
      # If grade has tags, find posts with same tags
      if grade.tags.any?
        tag_ids = grade.tags.pluck(:id)
        
        related_posts = Post.joins(:tags)
        .where(tags: { id: tag_ids })
        .group("posts.id")
        .select("posts.*, COUNT(tags.id) as match_count")
        .order("match_count DESC")
        .limit(limit)
        
        if related_posts.any?
          return related_posts.map do |post|
            {
              path: post_path(post),
              image_url: post.image.attached? ? url_for(post.image) : "https://images.unsplash.com/photo-1494412574643-ff11b0a5c1c3?auto=format&fit=crop&w=900&q=85",
              category: post.post_type || "Article",
              title: post.title,
              summary: post.summery.present? ? post.summery[0..117] + "..." : (post.content.present? ? post.content[0..117] + "..." : "Read more")
            }
          end
        end
      end

      # Fallback: Get latest posts
      Post.limit(limit).order(created_at: :desc).map do |post|
        {
          path: post_path(post),
          image_url: post.image.attached? ? url_for(post.image) : "https://images.unsplash.com/photo-1494412574643-ff11b0a5c1c3?auto=format&fit=crop&w=900&q=85",
          category: post.post_type || "Article",
          title: post.title,
          summary: post.summery.present? ? post.summery[0..117] + "..." : (post.content.present? ? post.content[0..117] + "..." : "Read more")
        }
      end
    end

    def normalize_slug
      self.slug = slug.to_s.parameterize if slug.present?
    end
  end