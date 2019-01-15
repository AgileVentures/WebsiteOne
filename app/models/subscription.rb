class Subscription < ApplicationRecord
  belongs_to :user, -> { with_deleted }
  belongs_to :plan

  validates_presence_of :started_at
  has_one :payment_source, class_name: 'PaymentSource::PaymentSource'
  belongs_to :sponsor, -> { with_deleted }, class_name: "User", foreign_key: :sponsor_id
  delegate :identifier, to: :payment_source

  def purchase
    response = EXPRESS_GATEWAY.purchase(plan.amount, express_purchase_options)
    response.success?
  end

  def express_token=(token)
    self[:express_token] = token
    if new_record? && token.present?
      # you can dump details var if you need more info from buyer
      details = EXPRESS_GATEWAY.details_for(token)
      self.express_payer_id = details.payer_id
    end
  end

  private

  def express_purchase_options
    {
      :ip => ip,
      :token => express_token,
      :payer_id => express_payer_id
    }
  end
end
