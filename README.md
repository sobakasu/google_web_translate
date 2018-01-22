[![Documentation](http://img.shields.io/badge/yard-docs-blue.svg)](http://www.rubydoc.info/gems/google_web_translate)
[![Gem Version](https://badge.fury.io/rb/google_web_translate.svg)](https://badge.fury.io/rb/google_web_translate)
[![Build Status](https://travis-ci.org/sobakasu/google_web_translate.svg?branch=master)](https://travis-ci.org/sobakasu/google_web_translate)

# GoogleWebTranslate

Translates text using the Google translate web interface.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'google_web_translate'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install google_web_translate

## Usage

### Command line

    google_web_translate "Hello" en de

### API

    api = GoogleWebTranslate::API.new
    result = api.translate("Hello", "en", "de")
    puts result.translation

    supported_languages = api.languages

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sobakasu/google_web_translate. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the GoogleWebTranslate project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/sobakasu/google_web_translate/blob/master/CODE_OF_CONDUCT.md).
