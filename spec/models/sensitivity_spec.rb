require File.dirname(__FILE__) + '/../spec_helper'

describe Sensitivity do
  it "should be valid" do
    Sensitivity.new.should be_valid
  end
end
