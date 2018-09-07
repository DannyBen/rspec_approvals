RSpec Fixtures
==================================================

[![Gem Version](https://badge.fury.io/rb/rspec_fixtures.svg)](https://badge.fury.io/rb/rspec_fixtures)
[![Build Status](https://travis-ci.com/DannyBen/rspec_fixtures.svg?branch=master)](https://travis-ci.com/DannyBen/rspec_fixtures)
[![Maintainability](https://api.codeclimate.com/v1/badges/a06ed5e30412062c454c/maintainability)](https://codeclimate.com/github/DannyBen/rspec_fixtures/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/a06ed5e30412062c454c/test_coverage)](https://codeclimate.com/github/DannyBen/rspec_fixtures/test_coverage)

---

RSpec Fixtures allows you to interactively review and approve testable
content. 

This is a *"What You See is What You Test"* for your specs, because 
*a Fixture is worth a thousand Mocks*... (too much?...)

![demo](demo.gif)

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