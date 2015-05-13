module Selene
  module ComponentValidator
    module ClassMethods
      def properties
        @properties ||= Hash.new({})
      end

      def properties=(properties)
        @properties = properties
      end

      def property(name, rules = {})
        properties[name] = rules
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end

    def self.inherited(subclass)
      subclass.properties = properties
    end

    def properties
      self.class.properties.keys
    end

    # Determine whether this property is required. Defauls to false.
    def required?(property_name)
      self.class.properties[property_name].fetch(:required, false)
    end

    # Determine whether this property can be set more than once. Defaults
    # to true.
    def multiple?(property_name)
      self.class.properties[property_name].fetch(:multiple, true)
    end

    def can_contain?(property)
      true
    end

    def can_add?(property)
      if contains?(property.name) && !multiple?(property.name)
        error(property.name, "property '%s' must not occur more than once" % property.name)
      end
      @errors.empty?
    end

    def error(property_name, message)
      @errors[property_name] << message
    end

    def valid?
      properties.select { |property_name| required?(property_name) }.each do |property_name|
        if !contains?(property_name)
          error(property_name, "missing required property '%s'" % property_name)
        end
      end
      @errors.empty?
    end
  end
end
