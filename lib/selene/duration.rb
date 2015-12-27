module Selene
  module Duration
    UNITS = %i(weeks days hours minutes seconds)

    def self.weeks(n)
      days(n * 7)
    end

    def self.days(n)
      hours(n * 24)
    end

    def self.hours(n)
      minutes(n * 60)
    end

    def self.minutes(n)
      seconds(n * 60)
    end

    def self.seconds(n)
      n
    end
  end
end
