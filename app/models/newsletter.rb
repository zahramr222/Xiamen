class Newsletter < ApplicationRecord
  before_validation :normalize_email

  validates :email,
            presence: true,
            length: { maximum: 254 },
            format: { with: URI::MailTo::EMAIL_REGEXP },
            uniqueness: { case_sensitive: false }

  private

  def normalize_email
    self.email = email.to_s.strip.downcase
  end
end