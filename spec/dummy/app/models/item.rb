class Item < ApplicationRecord
  has_many :item_details

  validates :field1,
            presence: true
end
