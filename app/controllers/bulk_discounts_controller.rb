class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @discounts = @merchant.bulk_discounts
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.new
  end
  
  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.find(params[:id])
  end

  def update
    merchant = Merchant.find(params[:merchant_id])
    discount = BulkDiscount.find(params[:id])
    discount.update!(bulk_discount_params)
    flash[:notice] = "Discount ##{discount.id} has been Updated!"
    redirect_to merchant_bulk_discount_path(merchant.id, discount.id)
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    @discount = @merchant.bulk_discounts.new(bulk_discount_params)
    if params[:bulk_discount][:quantity].blank? || params[:bulk_discount][:discount].blank?
      flash[:notice] = "One or more of the required fields is empty. Bulk Discount cannot be Created!"
      redirect_to new_merchant_bulk_discount_path(@merchant.id)
    elsif @discount.save
      flash[:notice] = "Discount##{@discount.id} has been Created!"
      redirect_to merchant_bulk_discounts_path(@merchant.id)
    end
  end

  def destroy
    merchant = Merchant.find(params[:merchant_id])
    discount = merchant.bulk_discounts.find(params[:id])
    discount.destroy
    flash[:notice] = "Discount ##{discount.id} has been Deleted!"
    redirect_to merchant_bulk_discounts_path(merchant.id)
  end

private
  def bulk_discount_params
    params.require(:bulk_discount).permit(:quantity, :discount)
  end
end