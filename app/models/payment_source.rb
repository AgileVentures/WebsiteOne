module PaymentSource

  class PaymentSource < ActiveRecord::Base
    belongs_to :subscription
  end

  class CraftAcademy < PaymentSource
  end

  class Stripe < PaymentSource
  end

  class PayPal < PaymentSource
  end
end
