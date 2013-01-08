require 'test_helper'

module Selene
  class AlarmBuilderTest < TestCase

    def builder
      @builder ||= AlarmBuilder.new
    end

    def test_parses_action
      parse_line 'ACTION', {}, 'AUDIO'
      assert_equal builder.component['action'], 'AUDIO'
    end

  end
end
