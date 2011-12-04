require File.dirname(__FILE__) + '/../spec_helper'

describe Flag do
  it "should be valid" do
    Flag.new.should be_valid
  end
end
