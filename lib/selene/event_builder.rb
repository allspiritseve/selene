module Selene
  class EventBuilder < ComponentBuilder

    # Required properties
    property 'DTSTAMP', required: true, multiple: false
    property 'UID', required: true, multiple: false

    # Optional properties
    property 'CLASS', multiple: false
    property 'CREATED', multiple: false
    property 'DESCRIPTION', multiple: false
    property 'DTEND', multiple: false
    property 'DTSTART', multiple: false
    property 'DURATION', multiple: false
    property 'GEO', multiple: false
    property 'LAST-MOD', multiple: false
    property 'LOCATION', multiple: false
    property 'ORGANIZER', multiple: false
    property 'PRIORITY', multiple: false
    property 'RECURID', multiple: false
    property 'RRULE' # The rrule property should not occur more than once (but can if necessary)
    property 'SEQ', multiple: false
    property 'STATUS', multiple: false
    property 'SUMMARY', multiple: false
    property 'TRANSP', multiple: false
    property 'URL', multiple: false
    property 'ATTACH'
    property 'ATTENDEE'
    property 'CATEGORIES'
    property 'COMMENT'
    property 'CONTACT'
    property 'EXDATE'
    property 'RDATE'
    property 'RELATED'
    property 'RELATED-TO'
    property 'RESOURCES'
    property 'RSTATUS'

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

    def parent=(builder)
      raise Exception.new("Event components cannot be nested inside anything but a calendar component") unless builder.is_a?(CalendarBuilder)
      super(builder)
    end

    def can_add?(property)
      if property.name == 'DTEND' && contains?('duration')
        error('DTEND', "The 'DTEND' property cannot be set if the 'DURATION' property already exists")
      elsif property.name == 'DURATION' && contains?('DTEND')
        error('DURATION', "The 'DURATION' property cannot be set if the 'DTEND' property already exists")
      end
      super(property)
    end

    def valid?
      if !contains?('DTSTART') && parent && !parent.contains?('METHOD')
        error('DTSTART', "The 'DTSTART' property is required if the calendar does not have a 'METHOD' property")
      end
      super
    end
  end
end
