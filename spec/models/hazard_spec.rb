require File.dirname(__FILE__) + '/../spec_helper'

describe Hazard do
  it "should be valid" do
    Hazard.new.should be_valid
  end
end
