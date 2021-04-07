class ItemRevenueSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :description, :unit_price, :merchant_id

  attribute :revenue do |item|
    Item.revenue(item.id)
  end
end
