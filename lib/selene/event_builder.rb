module Selene
  class EventBuilder < ComponentBuilder

    # These properties are required
    REQUIRED_PROPERTIES = %w(dtstamp uid)

    # These properties must not occur more than once
    DISTINCT_PROPERTIES = %w(dtstamp uid dtstart class created description geo
      last-mod location organizer priority seq status summary
      transp url recurid)

    # These properties must not occur together in the same component
    EXCLUSIVE_PROPERTIES = [
      %w(dtend duration)
    ]

    # require_property :dtstart, :if => lambda { |b| b.parent.key?['method'] }
    # single_property :rrule, :except => when?
    # if dtstart is a date, dtend has to be too
    # multi-day durations must be 'dur-day' or 'dur-week'
    # parent must be a calendar

    def value(line)
      case line.name
      when 'dtstamp', 'dtstart', 'dtend'
        line.value_with_params
      when 'geo'
        line.values
      else
        super
      end
    end

    def parent=(builder)
      raise Exception.new("Event components cannot be nested inside anything but a calendar component") unless builder.is_a?(CalendarBuilder)
      super(builder)
    end

    def component_rules(component)
      super(component).tap do |rules|
        rules["Property 'dtstart' required if the calendar does not specify a 'method' property"] = lambda do |message|
          return if @component.key?('dtstart') || parent && parent.component.key?('method')
          @errors << { :message => message }
        end
      end
    end

  end
end
