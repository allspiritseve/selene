module Selene
  class CalendarBuilder
    include BuilderHelper

    attr_reader :component, :errors

    validate :required => %w(prodid version)
    validate :single => %w(prodid version calscale method)

    # %w(calscale method).each do |property|
    #   validate property, :single
    # end

    single_property :prodid, :version, :calscale, :method
    require_property :prodid, :version

    def initialize
      @errors = []
      @component = Hash.new { |component, property| component[property] = [] }
    end

    def parse(line)
      if @component.key?(line.name) && single_property?(line.name)
        @errors << { :line => line, :message => "cannot have more than one '#{line.name}' property" }
      else
        @component[line.name] = line.value
      end
    end

    def append(builder)
      case builder
      when EventBuilder
        @component['events'] << builder.component
      when TimeZoneBuilder
        @component['time_zones'] << builder.component
      end
    end

  end
end
