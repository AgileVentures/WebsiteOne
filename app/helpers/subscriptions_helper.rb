module SubscriptionsHelper
  def paypal_return_url
    return "#{root_url}#{subscriptions_path}"
  end
end
