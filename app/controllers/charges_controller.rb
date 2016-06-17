class ChargesController < ApplicationController

def new
end

def create
   # Amount in cents
  @amount = 1000
  token = params[:stripeToken]

  customer = Stripe::Customer.create(
    card: token
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
