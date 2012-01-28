require File.dirname(__FILE__) + '/../spec_helper'

describe Store do
  it "should be valid" do
    Store.new.should be_valid
  end
end
