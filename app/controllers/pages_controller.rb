require "net/http"
require "json"

class PagesController < ApplicationController

  # =====================================================
  # ABOUT
  # =====================================================

  def about
    page_title = "About Global Synergy"

    page_description =
      "Learn more about Global Synergy, our experience in supplying and exporting bitumen and petroleum products, our global operations, quality standards and commitment to reliable international trade."

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
      { label: "About" }
    ]
  end


  # =====================================================
  # CONTACT
  # =====================================================

  def contact
    @contact = Contact.new

    set_contact_meta
  end


  # =====================================================
  # CREATE CONTACT
  # =====================================================

  def create_contact
    return head :unprocessable_entity if params[:website].present?

    @contact = Contact.new(contact_params)

    unless turnstile_valid?
      flash.now[:alert] =
        "Security verification failed. Please try again."

      set_contact_meta

      return render :contact,
                    status: :unprocessable_entity
    end

    if @contact.save
      redirect_to contact_path,
                  notice: "Your message was sent successfully."
    else
      flash.now[:alert] =
        "Please check the form and try again."

      set_contact_meta

      render :contact,
             status: :unprocessable_entity
    end
  end


  # =====================================================
  # CREATE NEWSLETTER
  # =====================================================

  def create_newsletter
    return head :unprocessable_entity if params[:website].present?

    @newsletter = Newsletter.new(newsletter_params)

    unless newsletter_turnstile_valid?
      redirect_back(
        fallback_location: root_path,
        alert: "Security verification failed. Please try again."
      )

      return
    end

    if @newsletter.save
      redirect_back(
        fallback_location: root_path,
        notice: "You have successfully subscribed to our newsletter."
      )
    else
      message =
        if @newsletter.errors.added?(:email, :taken)
          "This email is already subscribed."
        else
          "Please enter a valid email address."
        end

      redirect_back(
        fallback_location: root_path,
        alert: message
      )
    end
  end

  def privacy_policy
  page_title = "Privacy Policy"

  page_description =
    "Read the Global Synergy Privacy Policy and learn how we collect, use and protect personal information submitted through our website."

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
    { label: "Privacy Policy" }
  ]
  end


  private

  # =====================================================
  # CONTACT PARAMS
  # =====================================================

  def contact_params
    params.require(:contact).permit(
      :full_name,
      :phone,
      :message
    )
  end


  # =====================================================
  # NEWSLETTER PARAMS
  # =====================================================

  def newsletter_params
    params.require(:newsletter).permit(:email)
  end


  # =====================================================
  # CONTACT TURNSTILE
  # =====================================================

  def turnstile_valid?
    token = params["cf-turnstile-response"]
    
    return false if token.blank?

    secret_key =
      Rails.application.credentials.dig(
        :cloudflare,
        :turnstile,
        :secret_key
      )

    verify_turnstile(token, secret_key)
  end


  # =====================================================
  # NEWSLETTER TURNSTILE
  # =====================================================

  def newsletter_turnstile_valid?
    token = params["cf-turnstile-response"]

    return false if token.blank?

    secret_key =
      Rails.application.credentials.dig(
        :cloudflare,
        :turnstile,
        :secret_key
      )

    verify_turnstile(token, secret_key)
  end


  # =====================================================
  # TURNSTILE VERIFY
  # =====================================================

  def verify_turnstile(token, secret_key)
    return false if secret_key.blank?

    uri =
      URI(
        "https://challenges.cloudflare.com/turnstile/v0/siteverify"
      )

    response = Net::HTTP.post_form(
      uri,
      {
        "secret" => secret_key,
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


  # =====================================================
  # CONTACT SEO
  # =====================================================

  def set_contact_meta
    page_title = "Contact Global Synergy"

    page_description =
      "Contact Global Synergy for inquiries about bitumen, petroleum products, pricing, supply, shipping and international trade. Our team is ready to assist you."

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
      { label: "Contact" }
    ]
  end

end