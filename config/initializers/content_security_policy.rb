# Be sure to restart your server when you modify this file.

Rails.application.configure do
  config.content_security_policy do |policy|

    # Everything is blocked by default unless explicitly allowed below.
    policy.default_src :self

    # JavaScript
    #
    # self:
    #   Rails / Importmap application JavaScript
    #
    # unsafe_inline:
    #   Required by the inline scripts currently present in the application.
    #
    # Cloudflare:
    #   Turnstile CAPTCHA
    #
    # jsDelivr:
    #   D3, TopoJSON and world-atlas
    policy.script_src(
      :self,
      :unsafe_inline,
      "https://challenges.cloudflare.com",
      "https://cdn.jsdelivr.net"
    )

    # CSS
    #
    # unsafe_inline is currently required because the application
    # contains inline style attributes and <style> blocks.
    policy.style_src(
      :self,
      :unsafe_inline
    )

    # Images
    policy.img_src(
      :self,
      :data,
      :blob,
      "https://images.unsplash.com"
    )

    # Local fonts
    policy.font_src(
      :self,
      :data
    )

    # AJAX / fetch / external data requests
    #
    # jsDelivr is required for world-atlas JSON used by D3.
    # Cloudflare is required by Turnstile.
    policy.connect_src(
      :self,
      "https://cdn.jsdelivr.net",
      "https://challenges.cloudflare.com"
    )

    # Turnstile uses an iframe.
    policy.frame_src(
      :self,
      "https://challenges.cloudflare.com"
    )

    # Prevent plugins such as Flash / embedded objects.
    policy.object_src :none

    # Prevent <base> tag manipulation.
    policy.base_uri :self

    # Forms may only submit back to this website.
    policy.form_action :self

    # Prevent this website from being embedded by other websites.
    # Helps protect against clickjacking.
    policy.frame_ancestors :self
  end

  # Enforce the policy.
  config.content_security_policy_report_only = false
end