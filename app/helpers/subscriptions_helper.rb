module SubscriptionsHelper
  def action_text
    @sponsorship ? 'Sponsor' : 'Get'
  end

  def type
    @sponsorship ? 'Sponsorship' : 'Membership'
  end
end
