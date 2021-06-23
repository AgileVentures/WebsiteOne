# frozen_string_literal: true

module PaymentSource
  class PaymentSource < ApplicationRecord
    belongs_to :subscription
  end

  class CraftAcademy < PaymentSource
  end

  class Stripe < PaymentSource
  end

  class PayPal < PaymentSource
  end

  class Invoice < PaymentSource
  end

  class Other < PaymentSource
  end
end
