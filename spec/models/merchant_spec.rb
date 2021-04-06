require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many(:items) }
    it { should have_many(:invoice_items).through(:items) }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:customers).through(:invoices) }
    it { should have_many(:transactions).through(:invoices) }
  end

  before :each do
    setup_five_merchants_revenue
  end

  describe 'class methods' do
    describe '#top_merchants_by_revenue' do
      it 'returns the given quantity merchants that have made the most revenue' do
        expected = [@merchant_5, @merchant_4, @merchant_3]
        actual = Merchant.top_merchants_by_revenue(3)

        expect(actual).to eq(expected)

        expected_2 = [@merchant_5, @merchant_4, @merchant_3, @merchant_2, @merchant_1]
        actual_2 = Merchant.top_merchants_by_revenue(5)

        expect(actual_2).to eq(expected_2)

        merchant_6_with_history

        expected_3 = [@merchant_6, @merchant_5, @merchant_4]
        actual_3 = Merchant.top_merchants_by_revenue(3)

        expect(actual_3).to eq(expected_3)
      end
    end

    describe '#most_items_sold' do
      it 'returns the given quantity of merchants that have sold the most items' do
        expected = [@merchant_5, @merchant_4, @merchant_3]
        actual = Merchant.most_items_sold(3)

        expect(actual).to eq(expected)

        expected_2 = [@merchant_5, @merchant_4, @merchant_3, @merchant_2, @merchant_1]
        actual_2 = Merchant.most_items_sold(5)

        expect(actual_2).to eq(expected_2)

        merchant_6_with_history

        expected_3 = [@merchant_6, @merchant_5, @merchant_4]
        actual_3 = Merchant.most_items_sold(3)

        expect(actual_3).to eq(expected_3)
      end
    end
  end

  describe '#instance methods' do
    describe '#revenue' do
      it 'returns the total revenue of a single merchant' do
        expect(@merchant_1.revenue).to eq(10)
        expect(@merchant_2.revenue).to eq(40)
        expect(@merchant_3.revenue).to eq(90)
        expect(@merchant_4.revenue).to eq(160)
        expect(@merchant_5.revenue).to eq(250)
      end
    end

    describe '#items_sold' do
      it 'returns the total amount of items sold for a merchant' do
        expect(@merchant_1.items_sold_count).to eq(1)
        expect(@merchant_2.items_sold_count).to eq(2)
        expect(@merchant_3.items_sold_count).to eq(3)
        expect(@merchant_4.items_sold_count).to eq(4)
        expect(@merchant_5.items_sold_count).to eq(5)
      end
    end
  end
end
