require 'bundler/setup'
require 'debugger'
require 'minitest/autorun'
require 'minitest/reporters'
require 'minitest/mock'
require 'selene'

Minitest::Reporters.use!

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

    def assert_required builder, property
      builder.valid?
      assert_error builder, property, "missing required property '#{property}'"
    end

    def assert_single builder, property
      builder.parse(Line.new(property, {}, 'First Value'))
      original_value = builder.component[property]
      builder.parse(Line.new(property, {}, 'Second Value'))
      assert_error builder, property, "property '#{property}' must not occur more than once"
      assert_equal original_value, builder.component[property]
    end

    def assert_error builder, property, message
      assert builder.errors[property].any? { |e| e =~ /#{message}/ }, "#{builder.class.name}: #{message}"
    end
  end
end
