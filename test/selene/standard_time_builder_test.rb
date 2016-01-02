require 'test_helper'

module Selene
  class StandardTimeBuilderTest < MiniTest::Test
    include BuilderTestHelper

    def builder
      @builder ||= StandardTimeBuilder.new('STANDARD')
    end

    def test_parses_rrule
      builder.parse(Line.new('RRULE', 'FREQ=YEARLY;BYMONTH=3;BYDAY=2SU'))
      assert_equal "FREQ=YEARLY;BYMONTH=3;BYDAY=2SU", builder.component['RRULE']
    end
  end
end
