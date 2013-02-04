require 'test_helper'

module Selene
  class ComponentBuilderTest < MiniTest::Unit::TestCase

    def test_property_rules
      builder = create_builder
      builder.property :version, :required => true
      assert_equal builder.property_rules[:version], { :required => true }
    end

    def test_multiple_property_rules_merge
      builder = create_builder
      builder.property :version, :required => true
      builder.property :version, :multiple => false
      assert_equal builder.property_rules[:version],  { :required => true, :multiple => false }
    end

    def test_multiple_rules_overwrite
      builder = create_builder
      builder.property :version, :required => false
      builder.property :version, :required => true
      assert_equal builder.property_rules[:version], { :required => true }
    end

    private

    def create_builder
      @builder ||= Class.new do
        extend ComponentRules
        property_rules.clear
      end
    end

  end
end
