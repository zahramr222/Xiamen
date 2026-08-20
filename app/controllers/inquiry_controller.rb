class InquiryController < ApplicationController
  def inquiry
    @inquiry = Inquiry.new
  end

  def create
    @inquiry = Inquiry.new(inquiry_params)
    
    if @inquiry.save
      redirect_to root_path, notice: "Thank you! We'll get back to you within 12 hours."
    else
      render :inquiry, status: :unprocessable_entity
    end
  end

  private

  def inquiry_params
    params.require(:inquiry).permit(
      :full_name,
      :email,
      :phone,
      :company,
      :product,
      :packing,
      :country,
      :port_of_discharge,
      :details
    )
  end
end