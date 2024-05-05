class Menu < ApplicationRecord
  self.table_name = "menu"
  attr_accessor :image_base64
  belongs_to :category


end
