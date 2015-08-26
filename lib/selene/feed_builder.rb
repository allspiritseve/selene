module Selene
  class FeedBuilder < ComponentBuilder
    def initialize
      super('feed')
    end

    def can_contain?(builder)
      !%w(vevent vtimezone valarm standard daylight).include?(builder.name)
    end
  end
end
