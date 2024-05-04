class OrdersController < ApplicationController
  before_action :require_user_logged_in!
  before_action :require_user_profile, only: [:create]

  def create
    cart_items = session[:cart].map { |item_id, quantity| { item_id: item_id.to_i, quantity: quantity.to_i } }
    total_amount = calculate_total_amount(cart_items)

    if Current.user
      @order = Current.user.orders.build(
        added_items_data: cart_items.to_json,
        total_amount: total_amount,
        status: "pending"
      )
    end

    if @order.save
      session.delete(:cart)
      redirect_to orders_path, notice: 'Order placed successfully!'
    else
      redirect_to cart_path, alert: "Failed to place order! #{order.errors.full_messages.join(', ')}"
    end
  end

  def cancel
    @order = Order.find(params[:id])
    if @order.update(status: 'canceled')
      redirect_to orders_path, notice: 'Order canceled successfully!'
    else
      redirect_to @order, alert: 'Failed to cancel order.'
    end
  end


  def index
    if Current.user.admin?
      @orders = Order.all
      render 'admin_index'
    else
      @orders = Order.where(user_id: Current.user.id)
    end
  end

  def show
    @order = Order.find_by(order_id: params[:id])

    if @order
      if Current.user.admin? || @order.user_id == Current.user.id
        @added_items_data = JSON.parse(@order.added_items_data.gsub('\"', '"'))
        @items_with_images = @added_items_data.map do |item|
          menu_item = Menu.find(item['item_id'])
          {
            'item_id' => item['item_id'],
            'quantity' => item['quantity'],
            'name' => menu_item.item_name,
            'price' => menu_item.price,
            'image_base64' => Base64.encode64(menu_item.image)
          }
        end
      else
        redirect_to orders_path, alert: "You are not authorized to view this order."
      end
    else
      redirect_to orders_path, alert: "Order not found."
    end
  end


  def destroy
    @order = Order.find(params[:id])
    @order.destroy
    redirect_to orders_path, notice: 'Order was successfully deleted.'
  end

  private

  def require_user_profile
    unless Current.user.user_profile.present?
      redirect_to profile_edit_path, alert: "Please fill in your profile before placing an order."
    end
  end

  def calculate_total_amount(cart_items)
    total_amount = 0

    cart_items.each do |item|
      menu_item = Menu.find(item[:item_id])
      total_amount += menu_item.price * item[:quantity]
    end

    total_amount
  end

end
