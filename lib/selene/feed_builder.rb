module Selene
  class FeedBuilder < ComponentBuilder
    def can_contain?(builder)
      !%w(vevent vtimezone valarm standard daylight).include?(builder.name)
    end
  end
end
