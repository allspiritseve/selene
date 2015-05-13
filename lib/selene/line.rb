module Selene
  class Line < Struct.new(:name, :value, :params)

    # Match everything until we hit ';' (parameter separator) or ':' (value separator)
    NAME = /(?<name>[^:\;]+)/

    # Match everything until we hit ':' (value separator)
    PARAMS = /(?:\;(?<params>[^:]*))/

    # Match everything that's left
    VALUE = /(?<value>.*)/

    # Match everything that is not ';' (parameter separator)
    PARAM = /[^\;]+/

    # Match parameter key and value
    PARAM_KEY_VALUE = /(?<key>[^=]+)=(?<value>.*)/

    # Split a string into content lines
    def self.split(string, &block)
      separator = string.match(/\r\n|\r|\n/, &:to_s) || "\r\n"
      string.gsub("#{separator}\s", '').split(separator).map do |line_string|
        parse(line_string).tap do |line|
          block.call(line) if line && block
        end
      end
    end

    # convert line string into line object
    def self.parse(line_string)
      line_string.match(/#{NAME}#{PARAMS}?:#{VALUE}/) do |match|
        new(match[:name], match[:value], parse_params(match[:params]))
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

    def initialize(name, value, params = {})
      super(name.downcase, value, params)
    end

    def begin_component?
      name == 'begin'
    end

    def component_name
      value.downcase
    end

    def end_component?
      name == 'end'
    end

    def params?
      !params.empty?
    end

    def value_with_params
      params? ? [value, params] : value
    end

    def values_with_params
      params? ? [values, params] : values
    end

    def rrule
      Hash[values.map { |values| k, v = values.split('=', 2); [k.downcase, v] }]
    end

    def values
      value.split(/[;,]/)
    end
  end
end
