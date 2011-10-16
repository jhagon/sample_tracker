require File.dirname(__FILE__) + '/../spec_helper'

describe Group do
  it "should be valid" do
    Group.new.should be_valid
  end
end
