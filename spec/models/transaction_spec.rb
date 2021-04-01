require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe 'relationships' do
    it { should have_many(:items).through(:invoice) }
    it { should have_many(:customers).through(:invoice) }
  end
end
