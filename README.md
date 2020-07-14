# RSpec Approvals

[![Gem Version](https://badge.fury.io/rb/rspec_approvals.svg)](https://badge.fury.io/rb/rspec_approvals)
[![Build Status](https://github.com/DannyBen/rspec_approvals/workflows/Test/badge.svg)](https://github.com/DannyBen/rspec_approvals/actions?query=workflow%3ATest)
[![Maintainability](https://api.codeclimate.com/v1/badges/b6ca26de93d9236c706a/maintainability)](https://codeclimate.com/github/DannyBen/rspec_approvals/maintainability)

---

RSpec Approvals allows you to interactively review and approve testable
content. 

![Demo](demo/cast.svg)

---

## Install

```
$ gem install rspec_approvals
```

Or with bundler:

```ruby
gem 'rspec_approvals'
```

## Usage

Require the gem in your spec helper:

```ruby
# spec/spec_helper.rb
require 'rspec_approvals'
```

And use any of the matchers in your specs.

```ruby
describe 'ls' do
  it "works" do
    expect(`ls`).to match_approval('ls_approval')
  end
end
```

## Matchers

### `match_approval` - Compare Strings

Compare a string with a pre-approved approval.

```ruby
expect('some string').to match_approval('approval_filename')
```


### `output_approval` - Compare STDOUT/STDERR

Compare an output (stdout or stderr) with a pre-approved approval.

```ruby
expect { puts "hello" }.to output_approval('approval_filename')
expect { puts "hello" }.to output_approval('approval_filename').to_stdout
expect { $stderr.puts "hello" }.to output_approval('approval_filename').to_stderr

# The first two are the same, as the default stream is stdout.
```


### `raise_approval` - Compare raised exceptions

Compare a raised exception with a pre-approved approval.

```ruby
expect { raise 'some error' }.to raise_approval('approval_filename')
```

## Modifiers

### `diff` - String similarity

Adding `diff(distance)` to either `match_approval` or `output_approval` will
change the matching behavior. Instead of expecting the strings to be exactly
the same, using `diff` compares the strings using the 
[Levenshtein distance][levenshtein] algorithm.

In the below example, we allow up to 5 characters to be different.

```ruby
expect ('some string').to match_approval('approval_filename').diff(5)
expect { puts 'some string' }.to output_approval('approval_filename').diff(5)
```

### `except` - Exclude by regular expression

Adding `except(regex)` to either `match_approval` or `output_approval` will
modify the string under test before running. By default, the regular
expression will be replaced with `...`.

In the below example, we ignore the full path of the file.

```ruby
expect('path: /path/to/file').to match_approval('approval_filename').except(/path: .*file/)
```

You may provide a second argument, which will be used as an alternative
replace string:

In the below example, all time strings will be replaced with `HH:MM`:

```ruby
expect('22:30').to match_approval('approval_filename').except(/\d2:\d2/, 'HH:MM')
```

### `before` - Alter the string before testing

The `before(proc)` method is a low level method and should normally not be 
used directly (as it is used by the `except` modifier).

Adding `before(proc)` to either `match_approval` or `output_approval` will
call the block and supply the actual string. The proc is expected to return
the new actual string.

In the below example, we replace all email addresses in a string.

```ruby
expect('hello rspec@approvals.com').to match_approval('approval_filename').before ->(actual) do
  actual.gsub /\w+@\w+\.\w+/, 'some@email.com'
end

```

## Configuration

### `interactive_approvals`

By default, interactive approvals are enabled in any environment that 
does not define the `CI` or the `GITHUB_ACTIONS` environment variables.
You can change this by adding this to your `spec_helper`

```ruby
RSpec.configure do |config|
  config.interactive_approvals = false # or any logic
end
```

### `approvals_path`

By default, approvals are stored in `spec/approvals`. To change the path,
add this to your `spec_helper`.

```ruby
RSpec.configure do |config|
  config.approvals_path = 'spec/anywhere/else'
end
```

### `auto_approve`

If you wish to automatically approve all new or changed approvals, you can
set the `auto_approve` configuration option to `true`. By default, 
auto approval is enabled if the environment variable `AUTO_APPROVE` is set.

```ruby
RSpec.configure do |config|
  config.auto_approve = true # or any logic
end
```

This feature is intended to help clean up the approvals folder from old, no
longer used files. Simply run the specs once, to ensure they all oass, 
delete the approvals folder, and run the specs again with:

```
$ AUTO_APPROVE=1 rspec
```

### `strip_ansi_escape`

In case your output strings contain ANSI escape codes that you wish to avoid
storing in your approvals, you can set the `strip_ansi_escape` to `true`.

```ruby
RSpec.configure do |config|
  config.strip_ansi_escape = true
end
```

### `before_approval`

In case you need to alter the actual output globally, you can provide the
`before_approval` option with a proc. The proc will receive the actual
output - similarly to the `before` modifier - and is expectedd to return
a modified actual string.

```ruby
RSpec.configure do |config|
  config.before_approval = ->(actual) do
    # return the actual string, without IP addresses
    actual.gsub(/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/, '[IP REMOVED]')
  end
end
```

## Advanced Usage Tips

### Sending output directly to RSpecApprovals

In some cases, you might need to send output directly to the `RSpecApproval`
stream capturer.

An example use case, is when you are testing `Logger` output.

The `RSpecApproval#stdout` and `RSpecApproval#stderr` can be used as an
alternative to `$stdout` and `$stderr`. These methods both return the
`StringIO` object that is used by `RSpecApprovals` to capture the output.

For example, you can use this:

```ruby
logger = Logger.new(RSpecApprovals.stdout)
```

as an alternative to this:

```
logger = Logger.new($stdout)
```

### Consistent terminal width

In case you are testing standard output with long lines, you may encounter inconsistencies when testing on different hosts, with varying terminal width. In order to ensure consistent output to stdout, you may want to set a known terminal size in your `spec_helper`:

```ruby
ENV['COLUMNS'] = '80'
ENV['LINES'] = '24'
```

### Recommended rspec flags

For best results, it is recommended you configure rspec to use the
documentation format. Place the code below in a file named `.rspec`
in your project's directory:

```
--color
--format documentation
```

## Contributing / Support

If you experience any issue, have a question or a suggestion, or if you wish
to contribute, feel free to [open an issue][issues].


[levenshtein]: https://en.wikipedia.org/wiki/Levenshtein_distance
[issues]: https://github.com/DannyBen/rspec_approvals/issues
