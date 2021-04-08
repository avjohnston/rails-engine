class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  def self.top_merchants_by_revenue(quantity)
    joins(:transactions)
      .select('merchants.*, sum(invoice_items.unit_price * invoice_items.quantity) as revenue')
      .where('transactions.result = ?', 'success')
      .group(:id)
      .order('revenue desc')
      .limit(quantity)
  end

  def revenue
    transactions.where('transactions.result = ?', 'success')
                .where('invoices.status = ?', 'shipped')
                .pluck('sum(invoice_items.unit_price * invoice_items.quantity)')
                .first
                .round(2)
  end

  def self.most_items_sold(quantity)
    joins(:transactions)
      .select('merchants.*, sum(invoice_items.quantity) as items_sold')
      .where('transactions.result = ?', 'success')
      .group(:id)
      .order('items_sold desc')
      .limit(quantity)
  end

  def items_sold_count
    transactions.where('transactions.result = ?', 'success')
                .pluck('sum(invoice_items.quantity)')
                .first
  end

  def self.search_by_name(name)
    where('name ILIKE ?', "%#{name}%").order(:name)
  end
end
