class MerchantNameRevenueSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name

  attribute :revenue do |merchant|
    merchant.revenue
  end
end
