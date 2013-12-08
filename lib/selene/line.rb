module Selene
  class Line < Struct.new(:name, :params, :value)

    # Match everything until we hit ';' (parameter separator) or ':' (value separator)
    NAME = /(?<name>[^:\;]+)/

    # Match everything until we hit ':' (value separator)
    PARAMS = /(?:\;(?<params>[^:]*))/

    # Match everything that's left
    VALUE = /(?<value>.*)/

    # Match everything that is not ';' (parameter separator)
    PARAM = /[^\;]+/

    # Match everything before '='
    PARAM_KEY_VALUE = /(?<key>[^=]+)=(?<value>.*)/

    # Split a string into content lines
    def self.split(string)
      delimiter = string.scan(/\r\n?|\n/).first || "\r\n"
      string.gsub(/#{delimiter}\s/, '').split(delimiter).map { |line| parse(line) }
    end

    # Parse a content line into a line object
    def self.parse(content_line)
      content_line.match(/#{NAME}#{PARAMS}?:#{VALUE}/) do |match|
        return new(match[:name], parse_params(match[:params]), match[:value])
      end
    end

    # Parse a param string into a hash
    def self.parse_params(params_string)
      {}.tap do |params|
        return params unless params_string
        params_string.scan(PARAM).map do |param|
          param.match(PARAM_KEY_VALUE) do |match|
            params[match[:key].downcase] = match[:value]
          end
        end
      end
    end

    def initialize(name, params, value)
      super(name.downcase, params || {}, value)
    end

    def begin_component?
      name == 'begin'
    end

    def end_component?
      name == 'end'
    end

    def params?
      params && !params.empty?
    end

    def value_with_params
      params? ? [value, params] : value
    end

    def rrule
      Hash[values.map { |values| k, v = values.split('=', 2); [k.downcase, v] }]
    end

    def values
      value.split(';')
    end
  end
end
