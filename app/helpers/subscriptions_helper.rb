module SubscriptionsHelper
  def paypal_form_url
    return 'https://www.paypal.com/cgi-bin/webscr' if ENV['RAILS_ENV'] == 'production'
    'https://www.sandbox.paypal.com/cgi-bin/webscr'
  end

  def paypal_form_asset_url
    return 'https://www.paypalobjects.com' if ENV['RAILS_ENV'] == 'production'
    'https://www.sandbox.paypal.com'
  end
end
