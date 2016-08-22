class ChargesController < ApplicationController

  def new

  end

  def create
     # Amount in cents
    @amount = params[:amount]
    token = params[:stripeToken]

    current_credits = current_user.credits

    if current_user.parent_code != nil
      current_user.update_parent_user
      @final_amount = @amount - ( @amount * 0.25 )
      charge_metadata = {
        :coupon_code => current_user.parent_code,
        :coupon_discount => "25%"
      }
    else
      @final_amount = @amount 
    end  

    current_user.update(credits: current_credits+params[:credits].to_i)


    charge_metadata ||= {}

    customer = Stripe::Customer.create(
      card: token,
      email: current_user.email
    )


    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => @final_amount,
      :description => "Purchased #{params[:credis]} credits",
      :currency    => 'usd',
      :metadata    => charge_metadata
    )

  redirect_to edit_job_link_path(current_user.job_links.last)

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_charge_path
  end  

  private

  COUPONS = {}

  def get_discount(code)
    code = code.gsub(/\s+/, '')
    code = code.upcase
    COUPONS[code]
  end  

end
