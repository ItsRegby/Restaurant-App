class CartsController < ApplicationController
  def show
    @cart_items = Menu.where(item_id: session[:cart])
  end

  def clear
    session.delete(:cart)
    redirect_to cart_path, notice: 'Cart cleared!'
  end
end
