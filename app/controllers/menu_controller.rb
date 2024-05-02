class MenuController < ApplicationController
  def index
    @menu_items = Menu.all
    @menu_items.each do |item|
      item.image_base64 = Base64.encode64(item.image)
    end
  end
end