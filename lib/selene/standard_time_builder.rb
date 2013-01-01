module Selene
  class StandardTimeBuilder

    def initialize
      @component = {}
    end

    def component
      @component
    end

    def parse(name, params, value)
      @component[name.downcase] = value
    end
  end
end
