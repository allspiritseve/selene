module Selene
  class ComponentBuilder
    include BuilderHelper

    attr_reader :name
    attr_reader :component, :errors

    def initialize
      @errors = []
      @component = Hash.new { |component, property| component[property] = [] }
    end

    def parse(line)
      @component[line.name] = line.value
    end

  end
end
