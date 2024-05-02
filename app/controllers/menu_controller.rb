class MenuController < ApplicationController
  def index
    @menu_items = Menu.where(can_be_prepared: true)
    @menu_items.each do |item|
      item.image_base64 = Base64.encode64(item.image)
    end
  end
  def category
    @category_id = params[:category_id]
    @menu_items = Menu.where(category_id: @category_id, can_be_prepared: true)
    @menu_items.each do |item|
      item.image_base64 = Base64.encode64(item.image)
    end
    render 'index' # or whatever your index view is named
  end
end