class ItemDetail < ApplicationRecord
  include Gizzard::Mysql

  belongs_to :item
end
