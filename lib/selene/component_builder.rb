module Selene
  # This is the base class for all component builders.
  #
  # The component name is specified like this:
  #
  # component 'vcalendar'
  #
  # And then properties and property rules are specified like this:
  #
  # property 'version', :required => true, :multiple => false
  #
  # If :required is truthy, a component is not valid without that property.
  # If :multiple is falsy, a component can only have one of that property
  #
  # Custom rules can be implemented by overriding can_add?(property) or valid?
  class ComponentBuilder

    # Hash containing properties as keys and rules as values
    @property_rules = {}

    class << self
      attr_accessor :name, :property_rules
    end

    attr_accessor :component, :name, :parent, :errors

    def self.component(name)
      name = name
    end

    def self.property(name, rules = {})
      property_rules[name] = rules
    end

    def self.inherited(subclass)
      subclass.instance_variable_set('@property_rules', @property_rules)
    end

    def initialize
      @component = Hash.new { |component, property| component[property] = [] }
      @errors = Hash.new { |errors, property| errors[property] = [] }
    end

    def add(name, builder)
      @component[name] << builder.component
    end

    def parse(line)
      @component[name(line)] = value(line) if can_add?(line)
    end

    def name(line)
      line.name
    end

    def value(line)
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

    def can_add?(property)
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
