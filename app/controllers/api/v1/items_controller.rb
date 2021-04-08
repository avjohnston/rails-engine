class Api::V1::ItemsController < ApplicationController
  def index
    @objects = Item.page_helper(params[:page].to_i, params[:per_page].to_i)

    @serial = ItemSerializer.new(@objects)
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
    @item = Item.find(params[:id])
    Invoice.invoice_delete(@item.id)
    @item.destroy
  end

  private
  def item_params
    params.permit(:name, :description, :unit_price, :merchant_id)
  end
end
