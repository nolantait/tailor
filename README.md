# Tailor

Tailor your CSS utility classes to your components.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add inhouse-tailor

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install inhouse-tailor

## Usage

```ruby
theme = Tailor.new(container: "block")
theme.add(:container, "p-sm")
theme.add(:container, "flex")
theme.remove(:container, "p-sm")

theme[:container].to_s #=> "block flex"
```

```ruby
theme = Tailor.new(container: "block")
other_theme = Tailor.new(container: "inline-block")

merged = theme.merge(other_theme)
merged[:container].to_s #=> "block inline-block"

inherited = theme.inherit(other_theme)
inherited[:container].to_s #=> "block"

overridden = theme.override(other_theme)
overridden[:container].to_s #=> "inline-block"
```

```ruby
class MyStyle
  include Tailor::DSL

  style :container, ["justify-between"]
end

component = MyStyle.new
component.style[:container].to_s #=> "justify-between"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and the created tag, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/nolantait/tailor.

## License

The gem is available as open source under the terms of the [MIT
License](https://opensource.org/licenses/MIT).
