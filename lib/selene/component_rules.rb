module Selene
  module ComponentRules

    def property_rules(component)
      {}.tap do |rules|
        rules["property %s must not occur more than once"] = lambda do |property, line, message|
          invalid = @component.key?(property) && component.class::DISTINCT_PROPERTIES.include?(property)
          !invalid.tap { @errors << { :message => message % property } if invalid }
        end 

        rules["properties '%s' and '%s' cannot occur in the same component"] = lambda do |property, line, message|
          passed = true
          component.class::EXCLUSIVE_PROPERTIES.each do |properties|
            other_property = properties.find { |p| @component.key?(p) && p != property }
            next unless other_property
            passed = false
            @errors << { :message => message % [property, other_property] }
          end
        end
      end
    end

    def component_rules(component)
      {}.tap do |rules|
        rules["missing required property '%s'"] = lambda do |message|
          passed = true
          component.class::REQUIRED_PROPERTIES.each do |required|
            next if @component.key?(required)
            passed = false
            @errors << { :message => message % required }
          end
          passed
        end
      end
    end

  end
end
