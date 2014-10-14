require 'test_helper'

module Selene
  class DaylightSavingsTimeBuilderTest < MiniTest::Test
    include BuilderTestHelper

    def builder
      @builder ||= DaylightSavingsTimeBuilder.new('daylight')
    end

    def test_parses_rrule
      builder.parse(Line.new('RRULE', 'FREQ=YEARLY;BYMONTH=3;BYDAY=2SU'))
      assert_equal({ 'freq' => 'YEARLY', 'bymonth' => '3', 'byday' => '2SU' }, builder.component['rrule'])
    end
  end
end
