module Selene
  class StandardTimeBuilder < ComponentBuilder
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
