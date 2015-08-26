module Selene
  class StandardTimeBuilder < ComponentBuilder
    def initialize
      super('standard')
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
