class Api::V1::ItemsController < ApplicationController
  def index
    page
    per_page
    page_helper(ItemSerializer, Item)

    render json: @serial
  end

  def show
    @item = Item.find(params[:id])
    @serial = ItemSerializer.new(@item)

    render json: @serial
  end

  def item_merchant
    @merchant = Item.find(params[:id]).merchant
    @serial = MerchantSerializer.new(@merchant)

    render json: @serial
  end

  def create
    @item = Merchant.find(params[:merchant_id]).items.create(item_params)
    if @item.save
      @serial = ItemSerializer.new(@item)

      render json: @serial, status: :created
    end
  end

  def update
    @item = Item.find(params[:id])
    @item.update!(item_params)
    @serial = ItemSerializer.new(@item)

    render json: @serial, status: 200
  end

  def destroy
    Item.find(params[:id]).destroy
  end

  private
  def item_params
    params.permit(:name, :description, :unit_price, :merchant_id)
  end
end
