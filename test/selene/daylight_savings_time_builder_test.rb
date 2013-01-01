require 'test_helper'

module Selene
  class DaylightSavingsTimeBuilderTest < TestCase

    def builder
      @builder ||= DaylightSavingsTimeBuilder.new
    end

    def test_parses_rrule 
      builder.parse('RRULE', '', 'FREQ=YEARLY;BYMONTH=3;BYDAY=2SU')
      assert_equal builder.component['rrule'], { 'freq' => 'YEARLY', 'bymonth' => '3', 'byday' => '2SU' }
    end

  end
end
