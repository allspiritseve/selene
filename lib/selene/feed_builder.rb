module Selene
  class FeedBuilder < Builder

    def initialize
      @component = { 'vcalendar' => [] }
    end

    def component
      @component
    end

  end
end
