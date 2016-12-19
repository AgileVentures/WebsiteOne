module SubscriptionsHelper
  def paypal_return_url
    return "#{root_url}#{subscriptions_path}"
  end

  def action_text
    @sponsorship ? 'Sponsor Premium' : 'Get Premium'
  end

  def type
    @sponsorship ? 'Sponsorship' : 'Membership'
  end
end
