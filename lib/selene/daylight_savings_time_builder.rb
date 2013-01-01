module Selene
  class DaylightSavingsTimeBuilder

    def initialize
      @component = {}
    end

    def component
      @component
    end

    def parse(key, value)
      @component[key.downcase] = value
    end
  end
end
