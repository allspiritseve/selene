require 'bundler/setup'
require 'debugger'
require 'minitest/autorun'
require 'minitest/colorize'
require 'minitest/mock'
require 'selene'

module Selene
  class TestCase < MiniTest::Unit::TestCase

    def fixture(filename)
      File.read(File.join(File.dirname(__FILE__), 'fixtures', filename))
    end

  end
end

module Stubbable

  # stub :method => 'value'
  # stub :method, 'value'
  # stub :method { 'value' }

  def stub(hash_or_method, value_or_block = nil)
    if hash_or_method.is_a?(Hash)
      hash_or_method.each { |method, value| stub method, Proc.new { value } }
    elsif !value_or_block.is_a?(Proc)
      stub hash_or_method, Proc.new { value_or_block }
    else
      define_singleton_method hash_or_method, value_or_block
    end
  end

end
