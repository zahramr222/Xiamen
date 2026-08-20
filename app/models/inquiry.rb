class Inquiry < ApplicationRecord
  validates :full_name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, presence: true
  validates :company, presence: true
  validates :product, presence: true
  
  # Optional: Add scopes or methods as needed
end