require 'rails_helper'

RSpec.describe 'Merchant Bulk Discounts Show' do
  before :each do
    @merchant = Merchant.create!(name: 'Hair Care')

    @bulk_discount = BulkDiscount.create!(quantity: 10, discount: 20, merchant_id: @merchant.id)

    visit merchant_bulk_discount_path(@merchant, @bulk_discount)
  end

  describe 'User Story 4' do
    it "takes the visitor to the bulk discount show page they see the bulk discount's quantity threshold and percentage discount" do
      expect(page).to have_content("Discount ##{@bulk_discount.id}")
      expect(page).to have_content("Quantity threshold: #{@bulk_discount.quantity} items")
      expect(page).to have_content("Discount percentage: #{@bulk_discount.discount}%")
    end
  end

  describe 'User Story 5' do
    it 'shows the visior of the bulk discount show page a link to edit the bulk discount. 
    When click this link they ate taken to a new page with a form to edit the discount' do

    expect(page).to have_link("Edit this Bulk Discount", href: edit_merchant_bulk_discount_path(@merchant.id, @bulk_discount.id))

    click_link "Edit this Bulk Discount"

    expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant.id, @bulk_discount.id))
    end
  end
end