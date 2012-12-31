require 'test_helper'
require 'minitest/mock'

class Selene::CalendarBuilderTest < MiniTest::Unit::TestCase 

  def setup
    @builder = Selene::CalendarBuilder.new
  end

  def test_parse_prodid
    @builder.parse('PRODID', '-//Meetup//RemoteApi//EN')
    assert_equal @builder.component['prodid'], '-//Meetup//RemoteApi//EN'
  end

  def test_parse_version
    @builder.parse('VERSION', '2.0')
    assert_equal @builder.component['version'], '2.0'
  end

  def test_parse_calscale
    @builder.parse('CALSCALE', 'Gregorian')
    assert_equal @builder.component['calscale'], 'Gregorian'
  end

  def test_parse_method
    @builder.parse('METHOD', 'Publish')
    assert_equal @builder.component['method'], 'Publish'
  end

  def test_parse_x_prop
    @builder.parse('X-ORIGINAL-URL', 'http://www.google.com')
    assert_equal @builder.component['x-original-url'], 'http://www.google.com'
  end

  def test_append_event_builder
    event_builder = Selene::EventBuilder.new
    def event_builder.component
      { 'summary' => 'Birthday Party' }
    end
    @builder.append(event_builder)
    assert_equal @builder.component['events'], [event_builder.component]
  end

  def test_append_time_zone_builder
    time_zone_builder = Selene::TimeZoneBuilder.new
    def time_zone_builder.component
      { 'tzid' => 'America/Detroit' }
    end
    @builder.append(time_zone_builder)
    assert_equal @builder.component['time_zones'], [time_zone_builder.component]
  end

end
