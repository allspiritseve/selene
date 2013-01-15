# Selene

Selene is an iCalendar parser for Ruby. It takes a string in iCalendar format (RFC 5545) and outputs a serializable hash.

## Installation

Add this line to your application's Gemfile:

    gem 'selene'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install selene

## Usage

```ruby
ical = Selene.parse(File.read('calendar.ics'))
```

## Demo

I wrote a quick little ical to json Heroku app:

http://ical-to-json.herokuapp.com/

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Namesake

Selene is the Greek goddess of the moon, and also happens to be a vampire from the excellent film Underworld:

![Selene](http://corykaufman.com/images/selene.png)
