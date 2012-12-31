module Selene
  class DaylightSavingsTimeBuilder
    attr_accessor :component

    def initialize
      self.component = {}
    end

    def parse(key, value)
      component[key.downcase] = value
    end
  end
end
