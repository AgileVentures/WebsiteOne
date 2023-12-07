# Minitest requires you provide an assertions ivar for the context
# it is running within. We need this so that ActiveModel::Lint tests
# can successfully be run.
module MinitestAssertion
  def assertions
    @assertions ||= 0
  end

  def assertions=(value)
    @assertions = value
  end
end
