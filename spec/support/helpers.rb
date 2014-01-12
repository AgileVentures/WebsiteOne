module Helpers

  # Used to mimic the same method available in feature testing
  # ex.
  #   rendered.within('section#header') do |header|
  #     header.should have_link 'Log Out'
  #   end
  # String.class_eval used instead of class String because the latter loads this as a constant, not a method!
  # Some insight to difference here: http://stackoverflow.com/a/10339348/2197402
  String.class_eval do
    def within(selector)
      # https://github.com/jnicklas/capybara/issues/384#issuecomment-1667712
      Capybara.string(self).find(selector).tap do |selection|
        yield selection
      end
    end
  end

end