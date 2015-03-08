module Selene
  class DaylightSavingsTimeBuilder < ComponentBuilder
    def initialize
      super('daylight')
    end

    def value(line)
      case line.name
      when 'rrule'
        line.rrule
      else
        super
      end
    end
  end
end
