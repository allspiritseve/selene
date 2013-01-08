module Selene
  module BuilderHelper

    RULES = [:required, :single]

    def self.included(builder)
      builder.extend(ClassMethods)
    end

    module ClassMethods
      @@rules = {}

      RULES.each do |rule|
        @@rules[rule.to_sym] = []
        define_method "#{rule}_properties" do
          @@rules[rule.to_sym]
        end
      end

      def validate rules
        rules.each do |rule, properties|
          raise "Unknown validation rule '#{rule}'" unless RULES.include? rule
          @@rules[rule].push(*properties)
        end
      end
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
