module Selene
  class StandardTimeBuilder

    def initialize
      @component = {}
    end

    def component
      @component
    end

    def parse(line)
      @component[line[:name].downcase] = line[:value]
    end
  end
end
