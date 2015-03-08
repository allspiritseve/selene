require 'test_helper'

module Selene
  require 'tzinfo'
  class Event
    TIME_FORMAT = '%Y%m%dT%H%M%S'
    attr_accessor :dtstart, :tzid

    attr_reader :component

    def initialize(component = {})
      @component = component
    end

    def dtstart
      timezone.parse(@component.fetch('dtstart')[0])
    end

    def dtstart=(dtstart)
      @component['dtstart'] = if tzid
        [dtstart.strftime(TIME_FORMAT), { 'tzid' => tzid }]
      else
        dtstart.strftime(TIME_FORMAT)
      end
    end

    def tzid
      @tzid ||= @component.fetch('dtstart')[1]['tzid'] rescue nil
    end
  end

  class EventTest < MiniTest::Test
    TIME_FORMAT = '%Y%m%dT%H%M%S'
    def setup
      @now = Time.now
    end

    def test_set_dtstart
      event = Event.new('dtstart' => ['20110611T170000', { 'tzid' => 'America/Detroit' }])
      event.dtstart = @now
      component = event.component
      assert_equal [@now.strftime(TIME_FORMAT), { 'tzid' => 'America/Detroit' }], component['dtstart']
    end

    def test_set_dtstart_timezone
      event = Event.new
      event.tzid = 'America/Los_Angeles'
      event.dtstart = @now
      component = event.component
      assert_equal [@now.strftime(TIME_FORMAT), { 'tzid' => 'America/Los_Angeles' }], component['dtstart']
    end

    def test_set_dtstart_local
      event = Event.new
      event.dtstart = @now
      component = event.component
      assert_equal @now.strftime(TIME_FORMAT), component['dtstart']
    end
  end
end
