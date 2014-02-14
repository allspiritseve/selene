module FixtureHelper
  def fixture(filename)
    File.read(File.join(File.dirname(__FILE__), 'fixtures', filename))
  end
end
