# Clir

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/clir`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

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

[TODO] Reprendre toutes les méthodes

### Test state

~~~ruby
# Use it in test_helper.rb ou spec_helper.rb

require 'clir'

CLI.set_tests_on_with_marker
# => universal test marker.Whereever you call the app, test?
# will be true

# Don't forget to use :
CLI.unset_tests_on_with_marker
# … to remove test on
~~~


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/clir.

