require 'rails_helper'

RSpec.describe 'Merchant Bulk Discounts Index' do
  before :each do
    @merchant = Merchant.create!(name: 'Hair Care')

    @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
    @customer_2 = Customer.create!(first_name: 'Cecilia', last_name: 'Jones')
    @customer_3 = Customer.create!(first_name: 'Mariah', last_name: 'Carrey')
    @customer_4 = Customer.create!(first_name: 'Leigh Ann', last_name: 'Bron')
    @customer_5 = Customer.create!(first_name: 'Sylvester', last_name: 'Nader')
    @customer_6 = Customer.create!(first_name: 'Herber', last_name: 'Kuhn')

    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2)
    @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 2)
    @invoice_5 = Invoice.create!(customer_id: @customer_4.id, status: 2)
    @invoice_6 = Invoice.create!(customer_id: @customer_5.id, status: 2)
    @invoice_7 = Invoice.create!(customer_id: @customer_6.id, status: 1)

    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant.id)
    @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant.id)
    @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant.id)
    @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant.id)

    @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
    @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 1, unit_price: 8, status: 0)
    @ii_3 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 2)
    @ii_4 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_5 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_6 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_7 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)

    @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
    @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_3.id)
    @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_4.id)
    @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice_5.id)
    @transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice_6.id)
    @transaction6 = Transaction.create!(credit_card_number: 879799, result: 1, invoice_id: @invoice_7.id)
    @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_2.id)

    @bulk_discount_1 = BulkDiscount.create!(quantity: 10, discount: 20, merchant_id: @merchant.id)
    @bulk_discount_2 = BulkDiscount.create!(quantity: 15, discount: 30, merchant_id: @merchant.id)
    @bulk_discount_3 = BulkDiscount.create!(quantity: 2, discount: 5, merchant_id: @merchant.id)

    @holiday_info = SwagFacade.new.holiday.sort_by(&:date).take(3)

    visit merchant_bulk_discounts_path(@merchant)

  end
  describe 'User Story 1' do
    it 'shows the visitor all of their bulk discounts including the percentage discount and quantity thresholds' do
      within("#merchant_discount-#{@bulk_discount_1.id}") {
        expect(page).to have_content("Discount amount: 20.0%")
        expect(page).to have_content("Discount quantity threshold: 10 items")
      }
      within("#merchant_discount-#{@bulk_discount_2.id}") {
        expect(page).to have_content("Discount amount: 30.0%")
        expect(page).to have_content("Discount quantity threshold: 15 items")
      }
      within("#merchant_discount-#{@bulk_discount_3.id}") {
        expect(page).to have_content("Discount amount: 5.0%")
        expect(page).to have_content("Discount quantity threshold: 2 items")
      }
    end

    it 'has a link for each discount listed that directs to the show page for that discount' do
      within("#merchant_discount-#{@bulk_discount_1.id}") {
        expect(page).to have_link("Discount ##{@bulk_discount_1.id}", href: merchant_bulk_discount_path(@merchant.id, @bulk_discount_1.id))
      }
      within("#merchant_discount-#{@bulk_discount_2.id}") {
        expect(page).to have_link("Discount ##{@bulk_discount_2.id}", href: merchant_bulk_discount_path(@merchant.id, @bulk_discount_2.id))
      }
      within("#merchant_discount-#{@bulk_discount_2.id}") {
        expect(page).to have_link("Discount ##{@bulk_discount_2.id}", href: merchant_bulk_discount_path(@merchant.id, @bulk_discount_2.id))
      }

      click_link "Discount ##{@bulk_discount_1.id}"

      expect(current_path).to eq(merchant_bulk_discount_path(@merchant.id, @bulk_discount_1.id))
    end
  end

  describe 'User Story 2' do
    it 'When the user visits their bulk discounts index they see a link to create a new discount and When they click this link they are taken to a new page' do
      expect(page).to have_link('Create a new discount', href: new_merchant_bulk_discount_path(@merchant.id))

      click_link "Create a new discount"

      expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant.id))
    end
  end

  describe 'User Story 3' do
    it 'When a visitor visits the bulk discounts index, next to each bulk discount they see a link to delete it' do

      within("#merchant_discount-#{@bulk_discount_1.id}") {
        expect(page).to have_button("Delete Discount ##{@bulk_discount_1.id}")
      }
      within("#merchant_discount-#{@bulk_discount_2.id}") {
        expect(page).to have_button("Delete Discount ##{@bulk_discount_2.id}")
      }
      within("#merchant_discount-#{@bulk_discount_3.id}") {
        expect(page).to have_button("Delete Discount ##{@bulk_discount_3.id}")
      }
    end

    it 'When the visitor clicks this link they are redirected back to the bulk discounts index page and no longer see the discount listed' do
      within("#merchant_discount-#{@bulk_discount_2.id}") {
        click_button "Delete Discount ##{@bulk_discount_2.id}"
      }

      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant))
      
      expect(page).to_not have_content("Discount amount: 30.0%")
      expect(page).to_not have_content("Discount quantity threshold: 15 items")

      expect(page).to have_content("Discount ##{@bulk_discount_2.id} has been Deleted!")
    end
  end

  describe 'User Story 9' do
    it 'shows the visitor a section with a header of Upcoming Holidays
    and in this section the name and date of the next 3 upcoming US holidays are listed.' do
      within("#upcoming-holidays") {
        expect(page).to have_content("Upcoming Holidays:")

      }
      within("#holiday-#{@holiday_info.first.date}") {
        expect(page).to have_content("Holiday: Good Friday")
        expect(page).to have_content("Holiday Date: 2023-04-07")
      }
      within("#holiday-#{@holiday_info.second.date}") {
        expect(page).to have_content("Holiday: Memorial Day")
        expect(page).to have_content("Holiday Date: 2023-05-29")
      }
      within("#holiday-#{@holiday_info.third.date}") {
        expect(page).to have_content("Holiday: Juneteenth")
        expect(page).to have_content("Holiday Date: 2023-06-19")
      }
    end
  end
end