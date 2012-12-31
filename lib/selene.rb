require 'selene/parser'
require 'selene/version'

module Selene

  def self.parse(string)
    Parser.parse(string)
  end

end
