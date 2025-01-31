require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "validations" do
    it { should validate_presence_of :status }
    it { should validate_presence_of :customer_id }
  end
  describe "relationships" do
    it { should belong_to :customer }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many :transactions}
  end
  describe "instance methods" do
    before(:each) do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @merchant2 = Merchant.create!(name: 'Feet Care')
      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant2.id)
      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
      @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 5, unit_price: 10, status: 1)
      @bulk_discount_1 = BulkDiscount.create!(quantity: 9, discount: 20, merchant_id: @merchant1.id)
      @bulk_discount_2 = BulkDiscount.create!(quantity: 9, discount: 20, merchant_id: @merchant2.id)
    end
    
    it "total_merchant_revenue" do
      expect(@invoice_1.total_merchant_revenue(@merchant1)).to eq(90)
    end
    
    it 'dicounted_merchant_revenue' do
      expect(@invoice_1.discounted_merchant_revenue(@merchant1)).to eq(72)
    end
    
    it "total_revenue" do
      expect(@invoice_1.total_revenue).to eq(140)
    end
    
    it "discounted_revenue" do
      expect(@invoice_1.discounted_revenue).to eq(122)
    end
  end
end
