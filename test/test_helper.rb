require 'bundler/setup'
require 'debugger'
require 'minitest/autorun'
require 'minitest/colorize'
require 'selene'


class Selene::TestCase < MiniTest::Unit::TestCase

  def fixture(filename)
    File.read(File.join(File.dirname(__FILE__), 'fixtures', filename))
  end

end
