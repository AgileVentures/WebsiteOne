module SubscriptionsHelper
  def paypal_return_url
    return "#{root_url.chomp('/')}#{subscriptions_paypal_redirect_path}?item_number=#{current_user.slug}&item_name=#{@plan.name}&auth=#{cookies['_WebsiteOne_session']}"
  end

  def action_text
    @sponsorship ? 'Sponsor' : 'Get'
  end

  def type
    @sponsorship ? 'Sponsorship' : 'Membership'
  end
end
