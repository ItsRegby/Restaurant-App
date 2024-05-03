class ItemsController < ApplicationController
  def add_to_cart
    item_id = params[:item_id]
    item = Menu.find(item_id)
    session[:cart] ||= {}
    session[:cart][item_id] ||= 0
    if session[:cart][item_id].is_a?(Numeric)
      session[:cart][item_id] += 1
    else
      session[:cart][item_id] = 1
    end
    redirect_to menu_category_path(item.category_id), notice: "Dish \"#{item.item_name}\" added to the cart!"
  end

end