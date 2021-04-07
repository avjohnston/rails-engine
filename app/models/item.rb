class Item < ApplicationRecord
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items, dependent: :destroy
  has_many :transactions, through: :invoices
  belongs_to :merchant

  def self.most_revenue(quantity)
    joins(invoices: :transactions)
    .where('transactions.result = ?', 'success')
    .select("items.*, sum(invoice_items.quantity * invoice_items.unit_price) as total_revenue")
    .group(:id)
    .order('total_revenue desc')
    .limit(quantity)
  end

  def self.revenue(item_id)
    return 0 if successful_transactions(item_id).empty?
    successful_transactions(item_id).first.total_revenue.round(2)
  end

  def self.successful_transactions(item_id)
    joins(:transactions).select("items.*, sum(invoice_items.quantity * invoice_items.unit_price) as total_revenue").where('transactions.result = ?', 'success').where('invoice_items.item_id = ?', item_id).group(:id)
  end

  def self.search_by_name(name)
    where("name ILIKE ? or description LIKE ?", "%#{name}%", "%#{name}%").order(:name)
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
