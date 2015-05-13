require 'test_helper'

module Selene
  class ComponentBuilderTest < MiniTest::Test
    def test_sets_property_rules
      ComponentBuilder.property :version, :required => true
      assert_equal({ :required => true }, ComponentBuilder.properties[:version])
    end
  end
end
