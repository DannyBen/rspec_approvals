require 'spec_helper'
require 'io/console'

# Why is this spec even here? ... This is a weird one...
#
# 1. We used to use `$stdin.getch` to get user input
# 2. It seems `$stdin.getch` worked in ruby 2.4.2 without requiring
#    `io/console`.
# 3. Tests in all ruby versions passed on Travis, since `$stdin` is 
#    stubbed (here is a good reason why stubbing is problematic)
#
# So - since `$stdin` is still stubbed, we just want to make sure
# it responds to getch when tested on travis in other ruby versions

describe :stdin do
  it "responds to getch" do
    expect($stdin).to respond_to :getch
  end
end
