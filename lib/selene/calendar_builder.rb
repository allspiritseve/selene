module Selene
  class CalendarBuilder < ComponentBuilder
    property 'prodid', required: true, :multiple => false
    property 'version', :required => true, :multiple => false

    property 'calscale', :multiple => false
    property 'method', :multiple => false

    # Custom properties: x-prop, iana-prop
  end
end
