require 'test_helper'

module Selene
  class AlarmBuilderTest < MiniTest::Test
    include BuilderTestHelper

    def test_parses_action
      builder.parse(Line.new('ACTION', 'AUDIO'))
      assert_equal builder.component['action'], 'AUDIO'
    end

    private
    def builder
      @builder ||= AlarmBuilder.new('valarm')
    end
  end
end
