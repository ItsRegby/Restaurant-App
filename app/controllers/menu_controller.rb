class MenuController < ApplicationController
  before_action :require_admin, only: [:new, :create, :edit, :update, :destroy]
  def index
    if Current.user&.admin?
      @menu_items = Menu.all
    else
      @menu_items = Menu.where(can_be_prepared: true)
    end
    @menu_items.each do |item|
      item.image_base64 = Base64.encode64(item.image)
    end
  end
  def category
    @category_id = params[:category_id]
    if Current.user&.admin?
      @menu_items = Menu.where(category_id: @category_id)
    else
      @menu_items = Menu.where(category_id: @category_id, can_be_prepared: true)
    end
    @menu_items.each do |item|
      item.image_base64 = Base64.encode64(item.image)
    end
    render 'index'
  end
  def edit
    @menu_item = Menu.find(params[:id])
  end
  def update
    @menu_item = Menu.find(params[:id])

    if @menu_item.update(menu_params)
      image_data = params[:menu][:image]
      if image_data.present?
        new_image_data = image_data.read
        @menu_item.image = new_image_data
        @menu_item.save
      end

      redirect_to menu_path, notice: "Menu item updated successfully!"
    else
      render :edit
    end
  end

  def new
    @menu_item = Menu.new
  end

  def create
    @menu_item = Menu.new(menu_params)

    image_data = params[:menu][:image]

    @menu_item.image = image_data.read if image_data.present?

    if @menu_item.save
      redirect_to menu_path, notice: "Menu item added successfully!"
    else
      render :new
    end
  end
  def destroy
    @menu_item = Menu.find(params[:id])
    @menu_item.destroy
    redirect_to categories_path, notice: "Menu item deleted successfully!"
  end

  private

  def menu_params
    params.require(:menu).permit(:item_name, :description, :price, :category_id, :can_be_prepared, :image)
  end
  def require_admin
    unless Current.user&.admin?
      flash[:alert] = "You don't have permission to access this page."
      redirect_to home_path
    end
  end
  
end