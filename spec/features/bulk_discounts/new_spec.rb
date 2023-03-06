require 'rails_helper'

RSpec.describe 'Merchant Bulk Discounts New Page' do
  before :each do
    @merchant = Merchant.create!(name: 'Hair Care')

    visit new_merchant_bulk_discount_path(@merchant.id)
  end

  it 'shows the user a form to add a new bulk discount' do
    expect(page).to have_field(:bulk_discount_quantity)
    expect(page).to have_field(:bulk_discount_discount)
  end

  it 'When they fill in the form with valid data they are redirected back to the bulk discount index page where they see the new bulk discount listed' do
    fill_in :bulk_discount_quantity, with: 10
    fill_in :bulk_discount_discount, with: 20

    click_button "Create Bulk discount"
    
    expect(current_path).to eq(merchant_bulk_discounts_path(@merchant.id))

    expect(page).to have_content("Discount amount: 20.0%")
    expect(page).to have_content("Discount quantity threshold: 10 items")
  end

  it 'will not allow the user to create a bulk discount with an empty field' do
 
    click_button "Create Bulk discount"

    expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant.id))

    expect(page).to have_content("One or more of the required fields is empty. Bulk Discount cannot be Created!")
  end
end