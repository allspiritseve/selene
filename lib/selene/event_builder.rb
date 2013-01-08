module Selene
  class EventBuilder < ComponentBuilder

    require_property :dtstamp, :uid
    single_property :dtstamp, :uid, :dtstart

    def parse_value(line)
      case line.name
      when 'dtstamp', 'dtstart', 'dtend'
        line.value_with_params
      when 'geo'
        line.values
      else
        super
      end
    end

  end
end
