require "net/http"
require "json"

class Users::SessionsController < Devise::SessionsController
  before_action :verify_turnstile, only: :create

  private

  def verify_turnstile
    token = params["cf-turnstile-response"]

    unless turnstile_valid?(token)
      self.resource = resource_class.new(sign_in_params)

      flash.now[:alert] =
        "Security verification failed. Please try again."

      render :new, status: :unprocessable_entity
    end
  end

  def turnstile_valid?(token)
    return false if token.blank?

    secret_key =
      if Rails.env.production?
        Rails.application.credentials.dig(
          :cloudflare,
          :turnstile,
          :secret_key
        )
      else
        "1x0000000000000000000000000000000AA"
      end
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

    result["success"] == true

  rescue StandardError => e
    Rails.logger.error(
      "Login Turnstile verification error: #{e.class}"
    )

    false
  end
end