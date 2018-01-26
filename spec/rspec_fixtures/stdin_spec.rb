require 'spec_helper'

describe :stdin do
  it "responds to getc" do
    expect($stdin).to respond_to :getc
  end

  it "responds to getch" do
    expect($stdin).to respond_to :getch
  end
end
