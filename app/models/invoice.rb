class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  enum status: [:cancelled, 'in progress', :completed]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def discounted_revenue
    invoice_totals = invoice_items.joins(item: [merchant: :bulk_discounts])
    .select('sum(CASE WHEN invoice_items.quantity >= bulk_discounts.quantity 
            THEN (invoice_items.unit_price * invoice_items.quantity) - ((invoice_items.unit_price * invoice_items.quantity) * (bulk_discounts.discount / 100)) 
            ELSE invoice_items.unit_price * invoice_items.quantity END) as total_price')
    .group(:id)
    
    Invoice.from(invoice_totals).sum('total_price')
  end
end
