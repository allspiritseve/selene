require 'bundler/setup'
require 'debugger'
require 'minitest/autorun'
require 'minitest/colorize'
require 'minitest/mock'
require 'selene'

module Selene
  module Stubbable

    # Allowed syntax options:
    #
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

  module FixtureHelper
    def fixture(filename)
      File.read(File.join(File.dirname(__FILE__), 'fixtures', filename))
    end
  end

  module BuilderTestHelper

    # This is a helper method that takes a name, params and a value, turns them into a proper line hash,
    # and passes them to the builder to be parsed.
    def parse_line(name, params, value)
      builder.parse(Line.new(name, params, value))
    end

    def assert_required property
      builder.valid?
      message = "missing required property '#{property}'"
      assert builder.errors.any? { |e| e[:message] =~ /#{message}/ }, message
    end

    def assert_single property
      2.times { parse_line(property, {}, 'Some Value') }
      message = "cannot have more than one '#{property}' property"
      assert builder.errors.any? { |e| e[:message] =~ /#{message}/ }, message
    end

    def assert_multiple_values_do_not_overwrite property
      parse_line(property, {}, 'Some Value')
      value = builder.component[property].dup
      parse_line(property, {}, 'Another Value')
      assert_equal builder.component[property], value
    end
  end
end
