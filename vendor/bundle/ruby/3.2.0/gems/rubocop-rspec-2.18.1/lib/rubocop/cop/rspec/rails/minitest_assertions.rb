# frozen_string_literal: true

module RuboCop
  module Cop
    module RSpec
      module Rails
        # Check if using Minitest matchers.
        #
        # @example
        #   # bad
        #   assert_equal(a, b)
        #   assert_equal a, b, "must be equal"
        #   refute_equal(a, b)
        #
        #   # good
        #   expect(a).to eq(b)
        #   expect(a).to(eq(b), "must be equal")
        #   expect(a).not_to eq(b)
        #
        class MinitestAssertions < Base
          extend AutoCorrector

          MSG = 'Use `%<prefer>s`.'
          RESTRICT_ON_SEND = %i[assert_equal refute_equal].freeze

          # @!method minitest_assertion(node)
          def_node_matcher :minitest_assertion, <<-PATTERN
          (send nil? {:assert_equal :refute_equal} $_ $_ $_?)
          PATTERN

          def on_send(node)
            minitest_assertion(node) do |expected, actual, failure_message|
              prefer = replacement(node, expected, actual,
                                   failure_message.first)
              add_offense(node, message: message(prefer)) do |corrector|
                corrector.replace(node, prefer)
              end
            end
          end

          private

          def replacement(node, expected, actual, failure_message)
            runner = node.method?(:assert_equal) ? 'to' : 'not_to'
            if failure_message.nil?
              "expect(#{expected.source}).#{runner} eq(#{actual.source})"
            else
              "expect(#{expected.source}).#{runner}(eq(#{actual.source}), " \
                "#{failure_message.source})"
            end
          end

          def message(prefer)
            format(MSG, prefer: prefer)
          end
        end
      end
    end
  end
end
