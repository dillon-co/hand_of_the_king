class ChargesController < ApplicationController

def new
end

def create
   # Amount in cents
  @amount = 1997
  token = params[:stripeToken]

  current_credits = current_user.credits

  current_user.update(credits: current_credits+3)

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

rescue Stripe::CardError => e
  flash[:error] = e.message
  redirect_to new_charge_path
end  

end
