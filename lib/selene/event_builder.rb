module Selene
  class EventBuilder < ComponentBuilder

    # Required properties
    property 'dtstamp', required: true, multiple: false
    property 'uid', required: true, multiple: false

    # Optional properties
    property 'class', multiple: false
    property 'created', multiple: false
    property 'description', multiple: false
    property 'dtend', multiple: false
    property 'dtstart', multiple: false
    property 'duration', multiple: false
    property 'geo', multiple: false
    property 'last-mod', multiple: false
    property 'location', multiple: false
    property 'organizer', multiple: false
    property 'priority', multiple: false
    property 'recurid', multiple: false
    property 'rrule' # The rrule property should not occur more than once (but can if necessary)
    property 'seq', multiple: false
    property 'status', multiple: false
    property 'summary', multiple: false
    property 'transp', multiple: false
    property 'url', multiple: false
    property 'attach'
    property 'attendee'
    property 'categories'
    property 'comment'
    property 'contact'
    property 'exdate'
    property 'rdate'
    property 'related'
    property 'related-to'
    property 'resources'
    property 'rstatus'

    # Custom properties: x-prop, iana-prop

    # TODO: if dtstart is a date, dtend must be as well
    # TODO: multi-day durations must be 'dur-day' or 'dur-week'

    def self.update(component, properties)
      new('vevent', component).update_properties(properties)
    end

    def update_properties(properties)
      properties.inject(self.component) do |component, (name, value)|
        component = update_property(component, name, value)
        component
      end
    end

    def update_property(component, name, value)
      case name
      when 'dtstart'
        component.merge('dtstart' => [value.strftime('%Y%m%dT%H%M%S'), component['dtstart'][1]])
      else
        component
      end
    end

    def value(line)
      if line.params?
        [line.value, line.params]
      else
        line.value
      end
    end

    def parent=(builder)
      raise Exception.new("Event components cannot be nested inside anything but a calendar component") unless builder.is_a?(CalendarBuilder)
      super(builder)
    end

    def can_add?(property)
      if property.name == 'dtend' && contains?('duration')
        error('dtend', "The 'dtend' property cannot be set if the 'duration' property already exists")
      elsif property.name == 'duration' && contains?('dtend')
        error('duration', "The 'duration' property cannot be set if the 'dtend' property already exists")
      end
      super(property)
    end

    def valid?
      if !contains?('dtstart') && parent && !parent.contains?('method')
        error('dtstart', "The 'dtstart' property is required if the calendar does not have a 'method' property")
      end
      super
    end
  end
end
