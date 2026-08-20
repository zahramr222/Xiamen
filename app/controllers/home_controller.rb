class HomeController < ApplicationController
  def index
    @reports = Post.reports.order(updated_at: :desc).limit(4)
    @articles= Post.articles.order(updated_at: :desc).limit(2)
    @products = Product.limit(6).order(created_at: :desc)


  end
end