require File.dirname(__FILE__) + '/../spec_helper'

describe Popup do
  it "should be valid" do
    Popup.new.should be_valid
  end
end
