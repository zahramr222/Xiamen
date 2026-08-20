class PackingTag < ApplicationRecord
  belongs_to :packing
  belongs_to :tag
end
