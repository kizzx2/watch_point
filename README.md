# WatchPoint

Stop exactly where a variable gets changed (a.k.a. watchpoints or `trace_var` for all) and help you swim through (other people's) code faster.

According to [this page](http://www.ruby-doc.org/docs/ProgrammingRuby/html/trouble.html) on ruby-doc.org there used to be watchpoints built into RDebug but I can't seem to find it in 1.9.3 and 2.0.0 on Mac. It turned out to be quite easy to roll your own so here goes.

## Features

- Watch any variable; not just globals.
- Watch any types of objects.
- Watch arbitrary expressions.

## Example

```ruby
require 'watch_point'

def hello(girl)
  girl << " Baby"
  puts "Hello, #{girl}"
end

name = "Mary"

# Watch any variables!
WatchPoint.watch(name)

WatchPoint.enable

# Triggers watchpoint
hello(name)

WatchPoint.disable
```

You'll get a Pry prompt at the `hello` line:

    From: foo.rb @ line 4 Object#hello:

        3: def hello(girl)
     => 4:   girl << " Baby"
        5:   puts "Hello, #{girl}"
        6: end

    [1] pry(main)> 

## Watching custom objects

`WatchPoint` works out of the box with primitive mutable objects (e.g. `Array`, `Hash`, `String`). It uses the `hash` function to determine whether a variable has changed. So to support new objects make sure you include all "members of interest" of your class into the `hash` function. For example:

```ruby
require 'watch_point'

class Foo
  attr_accessor :one, :two

  def hash
    one.hash + two.hash
  end
end

f = Foo.new
f.one = "One"
f.two = "Two"

WatchPoint.watch(f)
WatchPoint.enable

# Triggers watchpoint
f.two = "Three"
```

## Watching an arbitrary expression

```ruby
require 'watch_point'

class Foo
  attr_accessor :one, :two

  def mutate(one, two)
    # Atomically swap the two values
    @one, @two = one, two
  end
end

f = Foo.new
f.one = 4
f.two = 6

# Define an anonymous class whose #hash method returns the value you
# want to watch
WatchPoint.watch(Class.new do
  define_method(:hash) do
    f.one + f.two
  end
end.new)
WatchPoint.enable

# Do not trigger watchpoint
f.mutate(6, 4)
f.mutate(0, 10)

# Triggers watchpoint
f.mutate(4, 3)
```

## Installation

Add this line to your application's Gemfile:

    gem 'watch_point'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install watch_point

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
