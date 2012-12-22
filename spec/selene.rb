require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

describe Selene do
 
  describe "when parsing" do
    let(:actual) { File.read('fixtures/mobile-monday.ics') }
    let(:expected) { File.read('fixtures/mobile-monday.json') }

    it "parses calendar" do
      Selene.parse(actual).should == JSON.parse(expected)
    end
  end

end
