require 'spec_helper'

# Why is this spec even here? ... This is a weird one...
#
# 1. We used to use `$stdin.getch` to get user input
# 2. It seems `$stdin.getch` is only available in ruby 2.4.2, and in other 
#    versions it is `$stdin.getc`
# 3. Tests in all ruby versions passed on Travis, since `$stdin` is 
#    stubbed (here is a good reason why stubbing is problematic)
# 4. We switched to using `$stdin.getc` but (sigh...) it is broken
#    in ruby 2.5, see this StackOverflow: https://goo.gl/uaSQMS
# 5. Finally, we switched to using gets instead.
#
# So - since `$stdin` is still stubbed, we just want to make sure
# ruby doesn't break its `gets` method...

describe :stdin do
  it "responds to gets" do
    expect($stdin).to respond_to :gets
  end
end
