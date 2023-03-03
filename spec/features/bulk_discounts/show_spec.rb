require 'rails_helper'

RSpec.describe 'Merchant Bulk Discounts Show' do
  before :each do
    @merchant = Merchant.create!(name: 'Hair Care')

    @bulk_discount = BulkDiscount.create!(quantity: 10, discount: 20, merchant_id: @merchant.id)

    visit merchant_bulk_discount_path(@merchant, @bulk_discount)
  end

  describe 'User Story 4' do
    it "When a visitor visits the bulk discount show page they see the bulk discount's quantity threshold and percentage discount" do
      expect(page).to have_content("Discount ##{@bulk_discount.id}")
      expect(page).to have_content("Quantity threshold: #{@bulk_discount.quantity} items")
      expect(page).to have_content("Discount percentage: #{@bulk_discount.discount}%")
    end
  end
end