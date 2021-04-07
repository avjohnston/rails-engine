require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'relationships' do
    it { should belong_to(:customer) }
    it { should have_many(:invoice_items) }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:transactions) }
  end

  describe '#class methods' do
    describe '#invoice_delete' do
      it 'deletes an invoice if the invoice has only one item on the invoice' do
        merchant_1_with_history
        merchant_4_with_history

        @invoice_9 = Invoice.create!(customer_id: @customer_1.id, status: 'completed', merchant_id: @merchant_1.id)
        InvoiceItem.create!(invoice_id: @invoice_9.id, item_id: @item_1.id, quantity: 4, unit_price: 40)

        Invoice.invoice_delete(@item_1.id)

        expect(@merchant_1.invoices).to eq([])

        InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_1.id, quantity: 4, unit_price: 40)
        Invoice.invoice_delete(@item_4.id)

        expect(@merchant_4.invoices).to eq([@invoice_4, @invoice_5])
      end
    end
  end
end
