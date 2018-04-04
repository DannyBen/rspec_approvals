RSpec Fixtures
==================================================

[![Gem](https://img.shields.io/gem/v/rspec_fixtures.svg?style=flat-square)](https://rubygems.org/gems/rspec_fixtures)
[![Travis](https://img.shields.io/travis/DannyBen/rspec_fixtures.svg?style=flat-square)](https://travis-ci.org/DannyBen/rspec_fixtures)
[![Maintainability](https://img.shields.io/codeclimate/maintainability/DannyBen/rspec_fixtures.svg?style=flat-square)](https://codeclimate.com/github/DannyBen/rspec_fixtures)
[![Issues](https://img.shields.io/codeclimate/issues/DannyBen/rspec_fixtures.svg?style=flat-square)](https://codeclimate.com/github/DannyBen/rspec_fixtures)
[![Dependencies](https://img.shields.io/gemnasium/DannyBen/rspec_fixtures.svg?style=flat-square)](https://gemnasium.com/DannyBen/rspec_fixtures)

---

RSpec Fixtures allows you to interactively review and approve testable
content.

[![asciicast](https://asciinema.org/a/150733.png)](https://asciinema.org/a/150733)

---



Install
--------------------------------------------------

```
$ gem install rspec_fixtures
```

Or with bundler:

```ruby
gem 'rspec_fixtures'
```



Usage
--------------------------------------------------

Require the gem in your spec helper:

```ruby
# spec/spec_helper.rb
require 'rspec_fixtures'
```

And use any of the matchers in your specs.

```ruby
describe 'ls' do
  it "works" do
    expect(`ls`).to match_fixture('ls_fixture')
  end
end
```



Matchers
--------------------------------------------------

### `match_fixture` - Compare Strings

Compare a string with a pre-approved fixture.

```ruby
expect('some string').to match_fixture('fixture_filename')
```


### `output_fixture` - Compare STDOUT/STDERR

Compare an output (stdout or stderr) with a pre-approved fixture.

```ruby
expect{ puts "hello" }.to output_fixture('fixture_filename')
expect{ puts "hello" }.to output_fixture('fixture_filename').to_stdout
expect{ $stderr.puts "hello" }.to output_fixture('fixture_filename').to_stderr

# The first two are the same, as the default stream is stdout.
```


### `diff` - String Similarity

Adding `diff(distance)` to either `match_fixture` or `output_fixture` will
change the matching behavior. Instead of expecting the strings to be exactly
the same, using `diff` compares the strings using the 
[Levenshtein distance][1] algorithm.

In the below example, we allow up to 5 characters to be different.

```ruby
expect('some string').to match_fixture('fixture_filename').diff(5)
expect{ puts 'some string' }.to output_fixture('fixture_filename').diff(5)
```



Configuration
--------------------------------------------------

### `interactive_fixtures`

By default, interactive approvals are enabled in any environment that 
does not define the `CI` environment variable. You can change this by
adding this to your `spec_helper`

```ruby
RSpec.configure do |config|
  config.interactive_fixtures = false # or any logic
end
```


### `fixtures_path`

By default, fixtures are stored in `spec/fixtures`. To change the path,
add this to your `spec_helper`.

```ruby
RSpec.configure do |config|
  config.fixtures_path = 'spec/anywhere/else'
end
```


[1]: https://en.wikipedia.org/wiki/Levenshtein_distance