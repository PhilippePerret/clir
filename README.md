# Clir

A lot of usefull methods to deal with CLI application and more. Its my Swizerland's Knife.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'clir'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install clir

## Usage

### String extensions

> Only some of them below.

~~~ruby
puts "Some texte in red".red

puts <<~EOT
This text is white.
#{'color follows'.yellow_} This text is also in yellow thanks
to the '_' after de color name.
EOT
~~~



### Test state

~~~ruby
# Use it in test_helper.rb ou spec_helper.rb

require 'clir'

CLI.set_tests_on_with_marker
# => universal test marker. Whereever you call the app, test?
# will be true

# Don't forget to use :
CLI.unset_tests_on_with_marker
# … to remove test on
~~~

### Mode test with interactive mode for TTY

When tests are ON, TTY::(My)Prompt toggle in `inputs_mode` so tests can send it the fake-user inputs. Sometimes though, tests use `Osascript` to run *real live test* (like if an user stokes real keys). In this case, `TTY::Prompt` must stay in `interactive mode`. To do so, tests have to call these methods:
~~~ruby

TTY::MyPrompt.set_mode_interactive
# => TTY:MyPrompt toggles in interactive mode during the tests

TTY::MyPrompt.set_mode_inputs
# => TTY::MyPrompt toggles in inputs mode during the tests (or not…)

~~~

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/clir.

