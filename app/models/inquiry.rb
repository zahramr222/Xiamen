class Inquiry < ApplicationRecord
  validates :full_name,
            presence: true,
            length: { maximum: 100 }

  validates :email,
            presence: true,
            length: { maximum: 254 },
            format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :phone,
            presence: true,
            length: { maximum: 30 }

  validates :company,
            presence: true,
            length: { maximum: 150 }

  validates :product, presence: true
  validates :packing, presence: true

  validates :country,
            presence: true,
            length: { maximum: 10 }

  validates :port_of_discharge,
            presence: true,
            length: { maximum: 150 }

  validates :details,
            presence: true,
            length: { minimum: 10, maximum: 3000 }

  validate :product_must_exist
  validate :packing_must_exist

  private

  def product_must_exist
    return if product.blank?

    unless Product.exists?(name: product)
      errors.add(:product, "is not a valid product")
    end
  end

  def packing_must_exist
    return if packing.blank?

    unless Packing.exists?(name: packing)
      errors.add(:packing, "is not a valid packing type")
    end
  end
end