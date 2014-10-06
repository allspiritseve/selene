module Selene
  # This is the base class for all component builders.
  #
  # Properties are specified one per property with optional rules, e.g.:
  #
  # property 'version', :required => true, :multiple => false
  #
  # If :required is truthy, a component is not valid without that property.
  # If :multiple is falsy, a component can only have one of that property
  #
  # Custom rules can be implemented by overriding can_add?(property) or valid?
  class ComponentBuilder
    @property_rules = {}

    class << self
      attr_accessor :property_rules
    end

    attr_reader :component, :stack, :errors, :name, :parent

    def self.property(name, rules = {})
      property_rules[name] = rules
    end

    def self.inherited(subclass)
      subclass.instance_variable_set('@property_rules', @property_rules)
    end

    def initialize(component, stack, errors)
      @component = component
      @stack = stack << self
      @errors = errors
    end

    def parse(line)
      @component[property_name(line)] = property_value(line) if can_add_property?(line)
    end

    def property_name(line)
      line.name
    end

    def component_name(line)
      line.name.downcase
    end

    def property_value(line)
      line.value
    end

    def contains_property?(property)
      @component.key?(property.to_s)
    end

    def can_contain?(component_name)
      true
    end

    def error(property, message)
      @errors[property] << message
    end

    def properties
      self.class.property_rules.keys
    end

    def required?(property)
      self.class.property_rules[property][:required]
    end

    def multiple?(property)
      self.class.property_rules[property][:multiple]
    end

    def can_add_property?(line)
      if contains_property?(property.name) && !multiple?(property.name)
        error(property.name, "property '%s' must not occur more than once" % property.name)
      end
      @errors.empty?
    end

    def valid?
      properties.select { |property| required?(property) }.each do |property|
        if !contains_property?(property)
          error(property, "missing required property '%s'" % property)
        end
      end
      @errors.empty?
    end
  end
end
