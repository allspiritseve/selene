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

    attr_accessor :component, :errors, :name, :parent

    def initialize(name)
      @name = name
      @component = Hash.new { |h, k| h[k] = [] }
      @errors = Hash.new { |h, k| h[k] = [] }
    end

    def add(name, builder)
      @component[name] << builder.component
    end

    def parse(*properties)
      properties.each do |property|
        case property
        when Line
          @component[name(property)] = value(property) if can_add?(property)
        when String
          Line.split(property).each { |line| parse(line) }
        else
          raise ParseError, "Cannot parse argument of type #{property.class}"
        end
      end
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

    def name(property)
      property.name
    end

    def value(property)
      property.value
    end

    def contains?(property)
      @component.key?(property)
    end
  end
end
