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

    describe '#successful_transactions' do
      it 'should return an active record association of the given item with revenue' do
        expect(Item.successful_transactions(@item_1.id)).to eq([@item_1])
        expect(Item.successful_transactions(@item_1.id).first.total_revenue).to eq(10)
        expect(Item.successful_transactions(@item_4.id)).to eq([])
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
end
