class CartsController < ApplicationController
  def show
    @cart_items = session[:cart].present? ? Menu.find(session[:cart].keys) : []
  end

  def clear
    session.delete(:cart)
    redirect_to cart_path, notice: 'Cart cleared!'
  end
  def remove_one
    item_id = params[:item_id]
    session[:cart][item_id] -= 1 if session[:cart][item_id] && session[:cart][item_id] > 0
    session[:cart].delete(item_id) if session[:cart][item_id] <= 0
    redirect_to cart_path, notice: 'One item removed from cart!'
  end

end
