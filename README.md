# WatchPoint

Stop exactly where a variable gets changed (a.k.a. watchpoints or `trace_var` for all) and help you swim through (other people's) code faster.

According to [this page](http://www.ruby-doc.org/docs/ProgrammingRuby/html/trouble.html) on ruby-doc.org there used to be watchpoints built into RDebug but I can't seem to find it in 1.9.3 and 2.0.0 on Mac. It turned out to be quite easy to roll your own so here goes.

## Installation

Add this line to your application's Gemfile:

    gem 'watch_point'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install watch_point

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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
