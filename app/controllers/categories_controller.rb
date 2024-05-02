class CategoriesController < ApplicationController
  def index
    @categories_items = Category.all
    @categories_items.each do |item|
      item.image_base64 = Base64.encode64(item.image)
    end
  end
end