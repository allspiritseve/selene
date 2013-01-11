module Selene
  class ComponentBuilder
    include ComponentRules

    attr_accessor :component, :parent, :errors

    REQUIRED_PROPERTIES = []
    DISTINCT_PROPERTIES = []
    EXCLUSIVE_PROPERTIES = []

    def add(name, builder)
      @component[name.downcase] << builder.component
      builder.parent = self
    end

    def initialize
      @component = Hash.new { |component, property| component[property] = [] }
      @errors = []
      @property_rules = property_rules(self)
      @component_rules = component_rules(self)
    end

    def parse(line)
      return unless @property_rules.all? { |message, rule| rule.call(name(line), line, message) }
      @component[name(line)] = value(line)
    end

    def name(line)
      line.name
    end

    def value(line)
      line.value
    end

    def a_component_rules
      @component_rules
    end

    def valid?
      @component_rules.each { |message, rule| rule.call(message) }
      @errors.empty?
    end

  end
end
