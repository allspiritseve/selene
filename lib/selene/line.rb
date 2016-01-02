module Selene
  class Line < Struct.new(:name, :value, :params, :context)
    def initialize(name, value, params = {}, context = {})
      super(name, value, params, context)
    end

    def value_with_params
      if !params.empty?
        [value, params]
      else
        value
      end
    end

    def to_a
      [key, value_with_params]
    end
  end

  # class Line < Struct.new(:name, :value, :index, :params)
  #   # Match everything until we hit ';' (parameter separator) or ':' (value separator)
  #   NAME = /(?<name>[\w-]+)/

  #   PARAMS = /(?<params>(\"[^\"]*\"|[^\:])*)/

  #   # Match everything that's left
  #   VALUE = /(?<value>.*)/

  #   REGEX = /#{NAME}(?:\;#{PARAMS})?:#{VALUE}/

  #   # Match everything that is not ';' (parameter separator)
  #   PARAM = /[^\;]+/

  #   # Match parameter key and value
  #   PARAM_KEY_VALUE = /(?<key>[^=]+)=(?<value>.*)/

  #   PARAM_MULTIPLE_VALUES = /\"[^\"]+\"|[^\,]+/

  #   def self.each(io, &block)
  #     separator = separator(io)
  #     io.read.gsub("#{separator}\s", '').split(separator).each_with_index.map do |line, index|
  #       Line.parse(line, index, &block)
  #     end
  #   end

  #   def self.separator(io)
  #     first_line = io.gets
  #     io.rewind
  #     /\r\n|\r|\n/.match(first_line).to_a.first || "\r\n"
  #   end

  #   # convert line string into line object
  #   def self.parse(line, index = nil, &block)
  #     line.match(REGEX) do |match|
  #       new(match[:name], match[:value], index, parse_params(match[:params]), &block)
  #     end
  #   end

  #   # Parse a param string into a hash
  #   def self.parse_params(params_string)
  #     {}.tap do |params|
  #       return params unless params_string
  #       params_string.scan(PARAM).map do |param|
  #         param.match(PARAM_KEY_VALUE) do |match|
  #           values = match[:value].scan(PARAM_MULTIPLE_VALUES)
  #           values = values.map do |value|
  #             if unquoted = value.match(/\"(?<value>[^\"]+)\"/)
  #               unquoted[:value]
  #             else
  #               value
  #             end
  #           end
  #           value = values.first unless values.length > 1
  #           value = values unless values.length == 1
  #           params[match[:key].upcase] = value
  #         end
  #       end
  #     end
  #   end

  #   def initialize(name, value, index = nil, params = {})
  #     super
  #     yield self if block_given?
  #   end

  #   def name
  #     self[:name].upcase
  #   end

  #   def params?
  #     !params.empty?
  #   end

  #   def value_with_params
  #     params? ? [value, params] : value
  #   end

  #   def values_with_params
  #     params? ? [values, params] : values
  #   end

  #   def rrule
  #     Hash[values.map { |values| k, v = values.split('=', 2); [k.upcase, v] }]
  #   end

  #   def values
  #     value.split(/[;,]/)
  #   end

  #   def to_ical
  #     if params
  #       ical_params = ';' + params.map do |key, value|
  #         out = [key]
  #         if value.is_a?(Array)
  #           out << value.map do |item|
  #             if item =~ /[\,\:\;]/
  #               "\"#{item}\""
  #             else
  #               item
  #             end
  #           end.join(',')
  #         else
  #           out << value
  #         end
  #         out.join('=')
  #       end.join(';')
  #     end
  #     "#{name}#{ical_params}:#{value}"
  #   end
  # end
end
