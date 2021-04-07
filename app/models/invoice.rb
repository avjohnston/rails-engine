class Invoice < ApplicationRecord
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items
  has_many :transactions, dependent: :destroy
  belongs_to :customer

  enum status: [:packed, :shipped, :returned]

  def self.invoice_delete(item_id)
    invoices = Item.find(item_id).invoices
    invoice_ids = invoices.joins(:invoice_items).select('invoices.*, count(invoice_items.item_id)').group(:id).having('count(invoice_items.item_id) = 1').pluck(:id)
    Invoice.destroy(invoice_ids)
  end
end
