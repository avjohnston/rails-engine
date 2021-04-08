require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { belong_to(:merchant) }
    it { should have_many(:invoice_items) }
    it { should have_many(:invoices).through(:invoice_items) }
  end
  before :each do
    setup_five_merchants_revenue
  end

  describe '#class methods' do
    describe '#most_revenue' do
      it 'should return the given quantity of items total revenue' do
        actual = Item.most_revenue(3)
        expected = [@item_6, @item_5, @item_3]

        expect(actual).to eq(expected)

        actual_2 = Item.most_revenue(5)
        expected_2 = [@item_6, @item_5, @item_3, @item_2, @item_1]

        expect(actual_2).to eq(expected_2)

        merchant_6_with_history

        actual_3 = Item.most_revenue(3)
        expected_3 = [@item_8, @item_6, @item_5]

        expect(actual_3).to eq(expected_3)
      end
    end

    describe '#search_by_name' do
      it 'should return items that match a partial search by name or description' do
        expect(Item.search_by_name('4')).to eq([@item_4])

        result = [@item_1, @item_2, @item_3, @item_4, @item_5, @item_6, @item_7]
        expect(Item.search_by_name('Ite')).to eq(result)

        expect(Item.search_by_name('ude')).to eq([@item_7])
        expect(Merchant.search_by_name('cwrvrgwer')).to eq([])
      end
    end

    describe '#min_price' do
      it 'should return items alphabetically that have a price greater than the argument' do
        expected = [@item_1, @item_2, @item_3, @item_4, @item_5, @item_6, @item_7]

        expect(Item.min_price(1)).to eq(expected)
        expect(Item.min_price(20)).to eq([@item_3, @item_5, @item_7])
        expect(Item.min_price(100)).to eq([])
      end
    end

    describe '#max_price' do
      it 'should return items alphabetically that have a price greater than the argument' do
        expected = [@item_1, @item_2, @item_4, @item_6]
        expected_2 = [@item_1, @item_2, @item_3, @item_4, @item_5, @item_6, @item_7]

        expect(Item.max_price(15)).to eq(expected)
        expect(Item.max_price(1000)).to eq(expected_2)
        expect(Item.max_price(0)).to eq([])
        expect(Item.max_price(-10)).to eq([])
      end
    end

    describe '#price_range' do
      it 'should return all items with a price that fall between the two arguments' do
        expected = [@item_1, @item_2, @item_4, @item_6]
        expected_2 = [@item_1, @item_2, @item_3, @item_4, @item_5, @item_6, @item_7]
        expected_3 = [@item_3, @item_5, @item_7]

        expect(Item.price_range(0, 15)).to eq(expected)
        expect(Item.price_range(0, 100)).to eq(expected_2)
        expect(Item.price_range(15, 25)).to eq(expected_3)
        expect(Item.price_range(100, 200)).to eq([])
        expect(Item.price_range(-100, -50)).to eq([])
        expect(Item.price_range(100, -100)).to eq([])
      end
    end
  end

  describe '#instance methods' do
    describe '#only_item_on_invoice' do
      it 'finds invoices with only itself on the invoice' do
        merchant_1_with_history
        merchant_4_with_history

        @invoice_9 = Invoice.create!(customer_id: @customer_1.id, status: 1, merchant_id: @merchant_1.id)
        InvoiceItem.create!(invoice_id: @invoice_9.id, item_id: @item_1.id, quantity: 4, unit_price: 40)

        @invoices = @item_1.only_item_on_invoice
        Invoice.destroy(@invoices)

        expect(@merchant_1.invoices).to eq([])

        InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_1.id, quantity: 4, unit_price: 40)

        @invoices2 = @item_1.only_item_on_invoice
        Invoice.destroy(@invoices2)

        expect(@merchant_4.invoices).to eq([@invoice_4, @invoice_5])
      end
    end

    describe '#revenue' do
      it 'should return the total revenue for a given item' do
        expect(@item_1.revenue).to eq(10)
        expect(@item_2.revenue).to eq(40)
        expect(@item_3.revenue).to eq(90)
        expect(@item_4.revenue).to eq(0)
        expect(@item_5.revenue).to eq(160)
        expect(@item_6.revenue).to eq(250)
        expect(@item_7.revenue).to eq(0)
      end
    end

    describe '#successful_transactions' do
      it 'should return an active record association of the given item with revenue' do
        expect(@item_1.successful_transactions).to eq([10])
        expect(@item_4.successful_transactions).to eq([nil])
      end
    end
  end
end
