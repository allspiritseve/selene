require 'test_helper'
require 'selene/line'

module Selene
  class LineTest < MiniTest::Test
    def test_value_with_params
      line1 = Line.new('SUMMARY', 'Summary')
      assert_equal 'Summary', line1.value_with_params

      line2 = Line.new('SUMMARY', 'Summary', { 'ONE' => 'UNO' })
      assert_equal ['Summary', { 'ONE' => 'UNO' }], line2.value_with_params
    end
  end
end
