module SubscriptionsHelper
  def paypal_return_url
    return "#{root_url.chomp('/')}#{subscriptions_paypal_redirect_path}"
  end

  def action_text
    @sponsorship ? 'Sponsor' : 'Get'
  end

  def type
    @sponsorship ? 'Sponsorship' : 'Membership'
  end
end
