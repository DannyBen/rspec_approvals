require 'spec_helper'

describe :stdin do
  it "responds to getc" do
    expect($stdin).to respond_to :getc
  end
end
