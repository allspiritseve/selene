{}.tap do |feed|
  lines.inject([]) do |stack, line|
    FeedBuilder.new(stack).handle(line)
  end
end
builder << line # BEGIN:VCALENDAR

class FeedHandler
  attr_reader :stack

  def initialize(stack)
    @stack = stack
  end

  def handle(stack, line)
    line.each do |line|
      if line.name == 'begin'
        begin_component(line)
      elsif line.name == 'end'
        stack.pop
      else
        stack[-1].parse(line)
      end
    end
  end

  def begin_component?(line)
    line.name == 'begin'
  end
end
