class Item < ApplicationRecord
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items, dependent: :destroy
  has_many :transactions, through: :invoices
  belongs_to :merchant

  def self.most_revenue(quantity)
    joins(invoices: :transactions)
      .where('transactions.result = ?', 'success')
      .select('items.*, sum(invoice_items.quantity * invoice_items.unit_price) as total_revenue')
      .group(:id)
      .order('total_revenue desc')
      .limit(quantity)
  end

  def successful_transactions
    invoices.joins(:transactions)
            .where('transactions.result = ?', 'success')
            .pluck('sum(invoice_items.quantity * invoice_items.unit_price)')
  end

  def revenue
    return 0 if successful_transactions.first.nil?

    successful_transactions.first.round(2)
  end

  def only_item_on_invoice
    invoices.joins(:items)
            .select('invoices.*, count(invoice_items.item_id)')
            .group(:id)
            .having('count(invoice_items.item_id) = 1')
            .pluck(:id)
  end

  def self.search_by_name(name)
    where('name ILIKE ? or description LIKE ?', "%#{name}%", "%#{name}%").order(:name)
  end

  def self.min_price(price)
    where('unit_price >= ?', price).order(:name)
  end

  def self.max_price(price)
    where('unit_price <= ?', price).order(:name)
  end

  def self.price_range(min, max)
    where('unit_price >= ? and unit_price <= ?', min, max).order(:name)
  end
end
