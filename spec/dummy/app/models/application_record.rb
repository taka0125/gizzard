class ApplicationRecord < ActiveRecord::Base
  include Gizzard::Mysql

  self.abstract_class = true
end
