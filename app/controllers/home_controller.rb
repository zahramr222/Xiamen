class HomeController < ApplicationController
  def index
    @reports = Post.reports
                   .order(updated_at: :desc)
                   .limit(4)

    @articles = Post.articles
                    .order(updated_at: :desc)
                    .limit(2)

    @products = Product.where(
  name: ["Slack Wax", "Footsoil", "Paraffin Wax", "Base Oil", "RPO"]
)

    home_description =
      "Global Synergy is a trusted bitumen supplier and exporter offering high-quality bitumen, slack wax, paraffin wax and petroleum products with competitive prices and reliable worldwide supply."

    set_meta_tags(
      title: "Bitumen Supplier & Exporter",
      description: home_description,

      og: {
        title: "Global Bitumen Supplier & Exporter | Global Synergy",
        description: home_description,
        type: "website",
        url: "#{request.base_url}#{request.path}",
        site_name: "Global Synergy"
      },

      twitter: {
        card: "summary_large_image",
        title: "Global Bitumen Supplier & Exporter | Global Synergy",
        description: home_description
      }
    )
  end
end

