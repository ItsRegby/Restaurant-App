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

  def update_status
    @order = Order.find(params[:id])
    if @order.update(order_params)
      redirect_to @order, notice: 'Order status updated successfully!'
    else
      redirect_to @order, alert: 'Failed to update order status.'
    end
  end

  def destroy_item
    @order = Order.find(params[:order_id])
    items = JSON.parse(@order.added_items_data)

    if items.length > 1
      item = items.find { |i| i['item_id'] == params[:item_id].to_i }
      if item
        item_price = item_price(item['item_id'])
        old_quantity = item['quantity'].to_i

        items.delete(item)
        @order.update(added_items_data: items.to_json)
        @order.total_amount -= old_quantity * item_price

        if @order.save
          redirect_to @order, notice: 'Item removed from order successfully!'
        else
          redirect_to @order, alert: 'Failed to save order after removing item.'
        end
      else
        redirect_to @order, alert: 'Failed to remove item from order.'
      end
    else
      redirect_to @order, alert: 'Cannot remove the last item from the order.'
    end
  end


  def update_quantity
    @order = Order.find(params[:order_id])
    items = JSON.parse(@order.added_items_data)

    item_to_update = items.find { |item| item['item_id'] == params[:id].to_i }

    if item_to_update
      old_quantity = item_to_update['quantity'].to_i
      new_quantity = params[:item][:quantity].to_i

      item_to_update['quantity'] = new_quantity
      @order.added_items_data = items.to_json

      @order.total_amount -= old_quantity * item_price(item_to_update['item_id'])
      @order.total_amount += new_quantity * item_price(item_to_update['item_id'])

      @order.status = 'pending'

      if @order.save
        redirect_to @order, notice: 'Item quantity updated successfully!'
      else
        redirect_to @order, alert: 'Failed to save order after updating item quantity'
      end
    else
      redirect_to @order, alert: 'Failed to update item quantity. Item not found in order.'
    end
  end
  def index
    @order_statuses = { 'pending' => 'pending', 'confirmed' => 'confirmed', 'shipped' => 'shipped', 'delivered' => 'delivered', 'canceled' => 'canceled' }
    if Current.user.admin?
      @orders = Order.all
      @orders = @orders.where(status: params[:status]) if params[:status].present?
      @orders = @orders.where("order_date >= ?", params[:start_date]) if params[:start_date].present?
      @orders = @orders.where("order_date <= ?", params[:end_date]) if params[:end_date].present?
      @orders = @orders.where("total_amount >= ?", params[:min_amount]) if params[:min_amount].present?
      @orders = @orders.where("total_amount <= ?", params[:max_amount]) if params[:max_amount].present?
      render 'admin_index'
    else
      @orders = Order.where(user_id: Current.user.id)
      @orders = @orders.where(status: params[:status]) if params[:status].present?
      @orders = @orders.where("order_date >= ?", params[:start_date]) if params[:start_date].present?
      @orders = @orders.where("order_date <= ?", params[:end_date]) if params[:end_date].present?
      @orders = @orders.where("total_amount >= ?", params[:min_amount]) if params[:min_amount].present?
      @orders = @orders.where("total_amount <= ?", params[:max_amount]) if params[:max_amount].present?
    end
  end

  def show
    @order = Order.find_by(order_id: params[:id])
    @order_statuses = { 'pending' => 'pending', 'confirmed' => 'confirmed', 'shipped' => 'shipped', 'delivered' => 'delivered' }

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
  def item_price(item_id)
    item = Menu.find_by(item_id: item_id)
    item.price if item
  end

  def order_params
    params.require(:order).permit(:status)
  end

  def require_user_profile
    unless Current.user.user_profile.present?
      redirect_to profile_edit_path, alert: "Please fill in your profile before placing an order."
    end
  end

  def calculate_total_amount(items)
    total_amount = 0

    items.each do |item|
      menu_item = Menu.find_by(item_id: item[:item_id])
      if menu_item
        total_amount += menu_item.price * item[:quantity]
      else
        puts "Menu item with id #{item[:item_id]} not found."
      end
    end

    total_amount
  end

end
