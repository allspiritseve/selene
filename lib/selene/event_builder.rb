module Selene
  class EventBuilder < ComponentBuilder

    component 'vevent'

    # Required properties
    property 'dtstamp', :required => true, :multiple => false
    property 'uid', :required => true, :multiple => false

    # Optional properties
    property 'class', :multiple => false
    property 'created', :multiple => false
    property 'description', :multiple => false
    property 'dtstart', :multiple => false
    property 'geo', :multiple => false
    property 'last-mod', :multiple => false
    property 'location', :multiple => false
    property 'organizer', :multiple => false
    property 'priority', :multiple => false
    property 'recurid', :mutiple => false
    property 'seq', :multiple => false
    property 'status', :multiple => false
    property 'summary', :multiple => false
    property 'transp', :multiple => false
    property 'url', :multiple => false
    property 'rrule' # The rrule property should not occur more than once (but can if necessary)
    property 'dtend', :multiple => false
    property 'duration', :multiple => false
    property 'attach'
    property 'attendee'
    property 'categories'
    property 'comment'
    property 'contact'
    property 'exdate'
    property 'rstatus'
    property 'related'
    property 'related-to'
    property 'resources'
    property 'rdate'

    # Custom properties: x-prop, iana-prop

    # TODO: if dtstart is a date, dtend must be as well
    # TODO: multi-day durations must be 'dur-day' or 'dur-week'

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

    def can_add?(line)
      if line.name == 'dtend' && contains_property?('duration')
        error('dtend', "The 'dtend' property cannot be set if the 'duration' property already exists")
      elsif line.name == 'duration' && contains_property?('dtend')
        error('duration', "The 'duration' property cannot be set if the 'dtend' property already exists")
      end
      super(line)
    end

    def valid?
      if !contains_property?('dtstart') && !parent.contains_property?('method')
        error('dtstart', "The 'dtstart' property is required if the calendar does not have a 'method' property")
      end
      super
    end

  end
end
