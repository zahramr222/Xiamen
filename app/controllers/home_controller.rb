class HomeController < ApplicationController
  def index
    @reports = Post.reports
                   .order(updated_at: :desc)
                   .limit(4)

    @articles = Post.articles
                    .order(updated_at: :desc)
                    .limit(2)

    @products = Product
                  .order(created_at: :desc)
                  .limit(6)

    home_description =
      "Xiamen is a global bitumen supplier and exporter providing premium bitumen and petroleum products with reliable worldwide shipping and competitive pricing."

    set_meta_tags(
      title: "Global Bitumen Supplier & Exporter",
      description: home_description,

      og: {
        title: "Global Bitumen Supplier & Exporter | Xiamen",
        description: home_description,
        type: "website",
        url: "#{request.base_url}#{request.path}",
        site_name: "Xiamen"
      },

      twitter: {
        card: "summary_large_image",
        title: "Global Bitumen Supplier & Exporter | Xiamen",
        description: home_description
      }
    )
  end
end

