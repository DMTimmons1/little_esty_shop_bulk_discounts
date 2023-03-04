require 'rails_helper'

RSpec.describe 'Merchant Bulk Discounts Edit' do
  before :each do
    @merchant = Merchant.create!(name: 'Hair Care')

    @bulk_discount = BulkDiscount.create!(quantity: 10, discount: 20, merchant_id: @merchant.id)

    visit edit_merchant_bulk_discount_path(@merchant.id, @bulk_discount.id)
  end

  describe 'User Story 5' do
    it "shows the visitor that the discount's current attributes are pre-poluated in the form." do
      expect(page).to have_field(:bulk_discount_quantity, with: @bulk_discount.quantity)
      expect(page).to have_field(:bulk_discount_discount, with: @bulk_discount.discount)
    end

    it "allows the vititor to make changes to any/all of the information. When they click submit, 
    they are redirected to the bulk discount's show page, and see that the discount's attributes have been updated" do
      fill_in :bulk_discount_quantity, with: 15
      fill_in :bulk_discount_discount, with: 35

      click_button "Update Bulk discount"
      
      expect(current_path).to eq(merchant_bulk_discount_path(@merchant.id, @bulk_discount.id))

      expect(page).to have_content("Discount percentage: 35%")
      expect(page).to have_content("Quantity threshold: 15 items")
      end
  end
end