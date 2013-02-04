require 'selene/parser'
require 'selene/version'

module Selene

  def self.parse(string)
    Parser.new.parse(string)
  end

end
