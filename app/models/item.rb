class Item < ApplicationRecord
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items, dependent: :destroy
  belongs_to :merchant

  def delete_invoice
    invoice_ids = Item.find(item_id).invoices.pluck('invoices.id')
    invoices.select('invoices.*, count(invoice_items.item_id)').group(:id)
  end
end
