# Jericho

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/jericho`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jericho'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jericho

## Usage
Small simple gem to clear you cucumber ```.json``` reports of redundant info and post results to Slack

Add ```Jericho.purify``` and ```Jericho.repent``` calls to ```at_exit``` hook of your Cucumber test suite and enjoy

Note that gem uses ```slack_ruby_client``` and ```dotenv``` to work properly

For gem to work properly:
1. Add it to your Gemfile (```gem 'jericho'```) and require it in your ```env.rb``` file (```require  'jericho'```)
2. Run your cucumber scenarios with ```cucumber --format json --out report" $(date)".json --format html --out report" $(date)".html --format pretty``` bash script
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/jericho. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
