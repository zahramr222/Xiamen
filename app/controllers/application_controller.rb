class ApplicationController < ActionController::Base
 include Pagy::Method

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  before_action :load_navigation

  private

  def load_navigation

    bitumen_names = [
      "Oxidized Bitumen",
      "Penetration Bitumen",
      "Cutback Bitumen",
      "Emulsion Bitumen"
    ]


    # =====================================================
    # BITUMEN PRODUCTS
    # =====================================================

    bitumen_products = Product
      .includes(:grades)
      .where(name: bitumen_names)


    # Keep the exact order we want in the header

    @nav_bitumen_products =
      bitumen_names.filter_map do |name|

        bitumen_products.find do |product|
          product.name == name
        end

      end


    # =====================================================
    # OTHER PRODUCTS
    # =====================================================

    @nav_products = Product
      .where.not(name: bitumen_names)
      .order(:name)

  end

  def set_record_meta_tags(record)
    record_name =
      if record.respond_to?(:name)
        record.name
      elsif record.respond_to?(:title)
        record.title
      else
        "Xiamen"
      end

    meta_title =
      if record.respond_to?(:meta_title) && record.meta_title.present?
        record.meta_title
      else
        record_name
      end

    meta_description =
      if record.respond_to?(:meta_description) && record.meta_description.present?
        record.meta_description
      else
        "Explore #{record_name} from Xiamen, a global supplier and exporter of bitumen and petroleum products."
      end

    page_url = "#{request.base_url}#{request.path}"

    image_url =
      if record.respond_to?(:image) && record.image.attached?
        url_for(record.image)
      end

    set_meta_tags(
      title: meta_title,
      description: meta_description,
      canonical: page_url,

      og: {
        title: "#{meta_title} | Xiamen",
        description: meta_description,
        type: "website",
        url: page_url,
        image: image_url,
        site_name: "Xiamen"
      },

      twitter: {
        card: "summary_large_image",
        title: "#{meta_title} | Xiamen",
        description: meta_description,
        image: image_url
      }
    )
  end

end
