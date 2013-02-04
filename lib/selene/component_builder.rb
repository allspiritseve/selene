module Selene
  class ComponentBuilder
    extend ComponentRules

    attr_accessor :component, :name, :parent, :errors

    def self.component(name)
      @name = name
      has_component_rules
    end

    def self.name
      @name
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

  end
end
