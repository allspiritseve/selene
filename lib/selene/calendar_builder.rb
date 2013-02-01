module Selene
  class CalendarBuilder < ComponentBuilder

    REQUIRED_PROPERTIES = %w(prodid version)

    DISTINCT_PROPERTIES = %w(prodid version calscale method)

    def method_blank?
      @component['method'].blank?
    end

  end
end
