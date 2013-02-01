module Selene
  module ComponentRules

    def has_component_rules
      @@property_rules = {}
      include InstanceMethods
    end

    def property(name, rules = {})
      @@property_rules[name] = rules
    end

    def property_rules
      @@property_rules
    end

    module InstanceMethods
      def property_rules
        self.class.property_rules
      end

      def properties
        property_rules.keys
      end

      def required?(property)
        !!property_rules[property][:required]
      end

      def multiple?(property)
        !!property_rules[property][:multiple]
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
end
