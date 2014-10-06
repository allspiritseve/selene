module Selene
  class Component < Hash
    def default(key = nil)
      []
    end

    def create_child_component(name)
      self.class.new do |child_component|
        self[name] << child_component
      end
    end
  end
end
