# Gizzard

[![Build Status](https://github.com/taka0125/gizzard/workflows/Ruby/badge.svg?branch=main)](https://github.com/taka0125/gizzard/actions)

Often use snippet for ActiveRecord.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gizzard'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gizzard

## Usage

Include modules in `ApplicationRecord` or `ActiveReocrd` class.

```ruby
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  include Gizzard::Base
  include Gizzard::Mysql
end
```

## Run Test

```
$ bundle install
$ docker-compose up -d
$ ./scripts/setup.sh
$ bundle exec rspec
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/taka0125/gizzard.
