require "spec_helper"

describe Sample do
  describe "sample_receipt" do
    let(:mail) { Sample.sample_receipt }

    it "renders the headers" do
      mail.subject.should eq("Sample receipt")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

  describe "sample_update" do
    let(:mail) { Sample.sample_update }

    it "renders the headers" do
      mail.subject.should eq("Sample update")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
