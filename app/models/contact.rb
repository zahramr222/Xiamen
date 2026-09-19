class Contact < ApplicationRecord
  validates :full_name,
            presence: true,
            length: { maximum: 100 }

  validates :phone,
            presence: true,
            length: { maximum: 30 }

  validates :message,
            presence: true,
            length: { minimum: 10, maximum: 3000 }
end
