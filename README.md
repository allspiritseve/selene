# Selene

Selene is a ruby iCalendar parser. It takes a string in iCalendar format (RFC 5545) and outputs a ruby hash.

## Installation

Add this line to your application's Gemfile:

    gem 'selene'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install selene

## Usage

```ruby
ical = Selene::Parser.parse(File.read('calendar.ics'))

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
