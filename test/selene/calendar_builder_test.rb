require 'test_helper'

class Selene::CalendarBuilderTest < MiniTest::Unit::TestCase 

  def setup
    @stack = []
    @builder = Selene::CalendarBuilder.new(@stack)
    @stack << @builder
  end

end
