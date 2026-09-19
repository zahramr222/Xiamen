require "net/http"
require "json"

class InquiryController < ApplicationController
  def inquiry
    @inquiry = Inquiry.new

    set_page_meta
  end

  def create
    # Honeypot
    return head :unprocessable_entity if params[:website].present?

    @inquiry = Inquiry.new(inquiry_params)

    # Cloudflare Turnstile verification
    unless turnstile_valid?
      @inquiry.errors.add(
        :base,
        "Please complete the security verification."
      )

      set_page_meta

      return render :inquiry,
                    status: :unprocessable_entity
    end

    if @inquiry.save
      redirect_to root_path,
              notice: "Your inquiry was sent successfully."
    else
      set_page_meta

      render :inquiry,
             status: :unprocessable_entity
    end
  end

  private

  def turnstile_valid?
    token = params["cf-turnstile-response"]

    return false if token.blank?

    secret_key =
      Rails.application.credentials.dig(
        :cloudflare,
        :turnstile,
        :secret_key
      )

    return false if secret_key.blank?

    uri = URI("https://challenges.cloudflare.com/turnstile/v0/siteverify")

    response = Net::HTTP.post_form(
      uri,
      {
        "secret"   => secret_key,
        "response" => token,
        "remoteip" => request.remote_ip
      }
    )

    return false unless response.is_a?(Net::HTTPSuccess)

    result = JSON.parse(response.body)

    if result["success"] == true
      true
    else
      Rails.logger.warn(
        "Turnstile rejected: #{result['error-codes']&.join(', ')}"
      )

      false
    end

rescue JSON::ParserError => e
  Rails.logger.error(
    "Turnstile invalid response: #{e.class}"
  )
  false

rescue StandardError => e
  Rails.logger.error(
    "Turnstile verification error: #{e.class}"
  )
  false
end

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

  def set_page_meta
    page_title = "Product Inquiry"

    page_description =
      "Send an inquiry to Global Synergy for bitumen and petroleum products, pricing, specifications, packing options, shipping and international supply."

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
      { label: "Inquiry" }
    ]
  end
end