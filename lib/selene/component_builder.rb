module Selene
  class ComponentBuilder
    attr_accessor :component, :parent, :errors

    @@property_rules = { :required => [], :single => [] }

    def self.required_properties
      @@property_rules[:required]
    end

    def self.single_properties
      @@property_rules[:single]
    end

    def self.require_property *properties
      @@property_rules[:required].push(*properties)
    end

    def self.single_property *properties
      @@property_rules[:single].push(*properties)
    end

    def add(name, builder)
      @component[name.downcase] << builder.component
      builder.parent = self
    end

    def initialize
      @component = Hash.new { |component, property| component[property] = [] }
      @errors = []
    end

    def parse(line)
      if @component.key?(line.name) && single_property?(line.name)
        @errors << { :line => line, :message => "cannot have more than one '#{line.name}' property" }
      else
        @component[line.name] = parse_value(line)
      end
    end

    def parse_value(line)
      line.value
    end

    def single_property?(property)
      self.class.single_properties.include?(property.to_sym)
    end

    def valid?
      validate_required_properties && @errors.empty?
    end

    def validate_required_properties
      self.class.required_properties.each do |property|
        @errors << { :message => "missing required property '#{property}'" } unless @component.key?(property)
      end
    end

  end
end
