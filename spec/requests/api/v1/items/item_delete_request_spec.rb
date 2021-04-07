require 'rails_helper'

RSpec.describe "Api::V1::Items", type: :request do
  before :each do
    @merchant = create(:merchant)
    @customer = create(:customer)
    @item = create(:item, merchant_id: @merchant.id)
    @invoice = create(:invoice, merchant_id: @merchant.id, customer_id: @customer.id, status: 1)
    @invoice_item = create(:invoice_item, item_id: @item.id, invoice_id: @invoice.id)
    @transaction = create(:transaction, invoice_id: @invoice.id)
  end

  describe 'happy path' do
    it 'deletes a item given a valid id' do
      delete api_v1_item_path(@item)

      expect(response).to have_http_status(204)
    end

    it 'deletes an invoice as well if the item is the only item on the invoice' do
      delete api_v1_item_path(@item)

      expect(response).to have_http_status(204)
      expect(@merchant.invoices).to eq([])
    end

    it 'doesnt delete an invoice the item is not the only item on the invoice' do
      @item_2 = create(:item, merchant_id: @merchant.id)
      @invoice_item_2 = create(:invoice_item, item_id: @item_2.id, invoice_id: @invoice.id)

      delete api_v1_item_path(@item)

      expect(response).to have_http_status(204)
      expect(@merchant.invoices).to eq([@invoice])
    end
  end

  describe 'sad path' do
    it 'cant delete an item given an invalid id' do
      expect{ delete api_v1_item_path(99999999) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
