module Selene
  class HashWithMultipleValues < Hash
    def initialize
      super do |hash, key|
        hash[key] = []
      end
    end

    def []=(key, value)
      if self.key?(key)
        if single_value?(self[key])
          super(key, [self[key], value])
        else
          super(key, self[key] + [value])
        end
      else
        super
      end
    end

    def single_value?(value)
      value.is_a?(String)
    end
  end

  class PropertyHash < HashWithMultipleValues
    def single_value?(value)
      !value.is_a?(Array) || value[0].is_a?(String)
    end
  end

  class ParamHash < HashWithMultipleValues
  end
end
