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

    describe '#revenue' do
      it 'should return the total revenue for a given item' do
        expect(Item.revenue(@item_1.id)).to eq(10)
        expect(Item.revenue(@item_2.id)).to eq(40)
        expect(Item.revenue(@item_3.id)).to eq(90)
        expect(Item.revenue(@item_4.id)).to eq(0)
        expect(Item.revenue(@item_5.id)).to eq(160)
        expect(Item.revenue(@item_6.id)).to eq(250)
        expect(Item.revenue(@item_7.id)).to eq(0)
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
  end
end
