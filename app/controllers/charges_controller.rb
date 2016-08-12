class ChargesController < ApplicationController

def new

end

def create
   # Amount in cents
  @amount = params[:amount]
  token = params[:stripeToken]

  current_credits = current_user.credits

  current_user.update(credits: current_credits+params[:credits].to_i)

  customer = Stripe::Customer.create(
    card: token,
    email: current_user.email
  )

  charge = Stripe::Charge.create(
    :customer    => customer.id,
    :amount      => @amount,
    :description => 'Apply',
    :currency    => 'usd'
  )

redirect_to edit_job_link_path(current_user.job_links.last)

rescue Stripe::CardError => e
  flash[:error] = e.message
  redirect_to new_charge_path
end  

end
