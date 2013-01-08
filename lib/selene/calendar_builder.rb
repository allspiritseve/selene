module Selene
  class CalendarBuilder < ComponentBuilder

    single_property :prodid, :version, :calscale, :method
    require_property :prodid, :version

  end
end
