# CIDB

[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.0-4baaaa.svg)](code_of_conduct.md) 

Continuous Investigation DataBase - Keep track of your Continuous Integration and stop it going bad.

## Status

This is an early sketch and experiment to feel out the problem space and build a minimum useful first pass.

Aiming to get running under github actions and import a jenkins builds from /var/jenkins.
Nothing ready to use yet...

Initial focus on the core problem in one repo as there are many way this could be done, especially once running in the cloud, which gets distracting.

## Installation


    $ gem install cidb

## Usage

TODO:

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rake test-unit` to run the tests. You can also run `./console` for an interactive prompt that will allow you to experiment.

Note that as the cidb command is a bash script to dispatch the sub commands, it confueses bundler. You need to give it a full path (prefix with `bin/`) to run the script under bash (and not try and parse it as ruby).

```
bundle exec bin/cidb scan --help
```

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

Add this line to your application's Gemfile:

```ruby
gem 'cidb'
```

And then execute:

    $ bundle install
## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/markpitchless/cidb. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/markpitchless/cidb/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Cidb project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/markpitchless/cidb/blob/master/CODE_OF_CONDUCT.md).
