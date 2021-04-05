class ItemsSoldSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name

  attribute :count do |merchant|
    merchant.items_sold_count
  end
end
