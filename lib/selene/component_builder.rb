require 'selene/component_validator'

module Selene
  # This is the base class for all component builders.
  #
  # Properties are specified one per property with optional rules, e.g.:
  #
  # property 'version', required: true, multiple: false
  #
  # If :required is truthy, a component is not valid without that property.
  # If :multiple is falsy, a component can only have one of that property
  #
  # Custom rules can be implemented by overriding can_add?(property) or valid?
  class ComponentBuilder
    include ComponentValidator

    class ParseError < StandardError; end

    attr_accessor :component, :errors, :name, :parent, :feed

    def initialize(name)
      @name = name
      @component = Hash.new { |h, k| h[k] = [] }
      @errors = Hash.new { |h, k| h[k] = [] }
    end

    def add(line, builder)
      if can_contain?(builder)
        @component[line.value] << builder.component
      else
        error(name, "can't contain #{builder.name}")
      end
    end

    def parse(line)
      if can_add?(line)
        @component[line.name] = value(line)
      end
    end

    def value(line)
      new_value = line.value_with_params
      return new_value unless contains?(line.name)
      previous_value = @component[line.name]
      if single_value?(previous_value)
        [previous_value, new_value]
      else
        previous_value + [new_value]
      end
    end

    def single_value?(value)
      !value.is_a?(Array) || value[0].is_a?(String)
    end

    def to_ical(component)
      lines = []
      component.each_pair do |key, value|
        keys = []
        values = []
        keys << key.upcase
        case value
        when Array
          if value[1].is_a?(Hash)
            value[1].each_pair do |pkey, pvalue|
              keys << [pkey.upcase, pvalue].join('=')
            end
            values << value[0]
          else
            values += value
          end
        when Hash
          value.each_pair do |vkey, vvalue|
            values << [vkey.upcase, vvalue].join('=')
          end
        end

        lines << [keys.join(';'), values.join(';')].join(':')
      end

      lines.join("\n")
    end

    def contains?(property)
      @component.key?(property)
    end
  end
end
