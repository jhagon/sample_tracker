require File.dirname(__FILE__) + '/../spec_helper'

describe Sample do
  it "should be valid" do
    Sample.new.should be_valid
  end
end
