module SubscriptionsHelper
  def paypal_return_url(user_receiving_benefit_slug)
    paypal = Paypal.new user_receiving_benefit_slug, @plan.name, current_user.email
    return "#{root_url.chomp('/')}#{subscriptions_paypal_redirect_path}?#{paypal.url_params}"
  end

  def action_text
    @sponsorship ? 'Sponsor' : 'Get'
  end

  def type
    @sponsorship ? 'Sponsorship' : 'Membership'
  end
end
