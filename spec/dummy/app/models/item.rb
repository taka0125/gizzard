class Item < ApplicationRecord
  include Gizzard::Mysql

  has_many :item_details

  validates :field1,
            presence: true
end
