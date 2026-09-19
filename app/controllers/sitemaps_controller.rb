class SitemapsController < ApplicationController
  def show
    @products = Product.order(:updated_at)
    @grades   = Grade.order(:updated_at)
    @packings = Packing.order(:updated_at)
    @posts    = Post.order(:updated_at)

    respond_to do |format|
      format.xml
    end
  end
end