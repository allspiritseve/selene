require 'test_helper'

module Selene
  class HashWithMultipleValuesTest < MiniTest::Test
    def test_hash
      hash = ParamHash.new
      hash[:one] = 'Uno'
      hash[:one] = 'Un'
      hash[:two] = 'Dos'
      assert_equal ['Uno', 'Un'], hash[:one]
      assert_equal 'Dos', hash[:two]

      hash = PropertyHash.new
      hash[:one] = ['Uno']
      hash[:one] = ['Un', {}]
      hash[:two] = ['Dos', {}]
      hash[:three] = 'Tres'
      assert_equal [['Uno'], ['Un', {}]], hash[:one]
      assert_equal ['Dos', {}], hash[:two]
      assert_equal 'Tres', hash[:three]
    end
  end
end
