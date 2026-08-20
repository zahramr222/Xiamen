class SpecificationsController < ApplicationController
  before_action :set_specification, only: [:edit, :update, :destroy]

  def index
    @specifications = Specification.all
  end

  def new
    @specification = Specification.new
  end

  def create
    @specification = Specification.new(specification_params)

    if @specification.save
      redirect_to specifications_path, notice: "Specification created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @specification.update(specification_params)
      redirect_to specifications_path, notice: "Specification updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @specification.destroy
    redirect_to specifications_path, notice: "Specification deleted successfully."
  end

  private

  def set_specification
    @specification = Specification.find(params[:id])
  end

  def specification_params
    params.require(:specification).permit(
      :title,
      :content,
      :grade_id  # ADD THIS - allows assigning to a grade
    )
  end
end