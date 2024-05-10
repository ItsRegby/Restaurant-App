class TableReservationsController < ApplicationController
  before_action :require_user_logged_in!, only: [:new, :create]
  before_action :require_user_profile, only: [:new, :create]

  def index
    if Current.user.admin?
      @reservations = TableReservations.all
      @reservations = @reservations.where(table_id: params[:table_id]) if params[:table_id].present?
      @reservations = @reservations.where(user_id: params[:user_id]) if params[:user_id].present?
      @reservations = @reservations.where("special_requests LIKE ?", "%#{params[:special_requests]}%") if params[:special_requests].present?
      render 'admin_index'
    else
      @reservations = TableReservations.where(user_id: Current.user.id)
      @reservations = @reservations.where(table_id: params[:table_id]) if params[:table_id].present?
      @reservations = @reservations.where(user_id: params[:user_id]) if params[:user_id].present?
      @reservations = @reservations.where("special_requests LIKE ?", "%#{params[:special_requests]}%") if params[:special_requests].present?
    end
  end
  def new
    @reservations = TableReservations.new
    @tables = Tables.where(can_be_reserved: true).order(table_id: :asc).pluck(:table_id)
    puts "@tables: #{@tables.inspect}"
  end

  def destroy
    @reservation = TableReservations.find(params[:id])
    @reservation.destroy
    redirect_to reservations_path, notice: 'Reservation was successfully deleted.'
  end

  def create
    @reservations = Current.user.table_reservations.build(reservation_params)
    @cart_items = session[:cart]

    if @reservations.save
      if params[:table_reservations][:convert_to_order] == "1" && @cart_items.present?
        order = create_order_for_reservation(@reservations)
        @reservations.update(order_id: order.order_id) if order
      end

      @table = Tables.find(reservation_params[:table_id])
      @table.update(can_be_reserved: false)
      flash[:success] = 'Reservation created successfully!'
      redirect_to home_path
    else
      flash[:error] = 'Failed to create reservation'
      render :new
    end
  end

  private

  def reservation_params
    params.require(:table_reservations).permit(:table_id, :order_id, :reservation_date, :special_requests)
  end
  def require_user_profile
    unless Current.user.user_profile.present?
      redirect_to profile_edit_path, alert: "Please fill in your profile before placing an order."
    end
  end

  def create_order_for_reservation(reservation)
    cart_items = session[:cart].map { |item_id, quantity| { item_id: item_id.to_i, quantity: quantity.to_i } }
    total_amount = calculate_total_amount(cart_items)

    @order = Current.user.orders.build(
      added_items_data: cart_items.to_json,
      total_amount: total_amount,
      status: "pending",
      reservation_id: reservation.id
    )

    if @order.save
      session.delete(:cart)
      return @order
    else
      flash[:error] = 'Failed to create order'
      redirect_to cart_path
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