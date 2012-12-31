require 'test_helper'

class Selene::CalendarBuilderTest < MiniTest::Unit::TestCase 

  def setup
    @builder = Selene::CalendarBuilder.new
    @equivalent_properties = %w(prodid version calscale method)
  end

  @equivalent_properties.each do |property|
    define_method "test_parsing_#{property}_property" do
      'some value'.tap do |value|
        @builder.parse(property.upcase, value)
        assert_equal @builder.component[property], value
      end
    end
  end

end
