Rails.configuration.stripe = {
  :publishable_key => 'pk_test_jcjMPgneaF1NtY3KYVWWXNNc',
  :secret_key      => 'sk_test_JJUC9VeCStYpevtDBX9p4UmP'
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]