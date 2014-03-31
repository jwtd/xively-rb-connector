require 'spec_helper'

describe XivelyConnector::Device do

  describe ".find" do

    it "should use an existing connection if it exists" do
      XivelyConnector.disconnect
      XivelyConnector.connect(:api_key=>"abcdefg")
      expect {XivelyConnector::Device.find('000000001')}.not_to raise_error
    end

    it "should raise an error if a connection doesn't exists and no api_key is provided" do
      XivelyConnector.disconnect
      expect {XivelyConnector::Device.find('000000001')}.to raise_error
    end

    it "should return a device object" do
      d = XivelyConnector::Device.find('000000001', "abcdefg")
      d.title.should == 'Smart Meter'
    end

  end

  describe ".find_by_id" do

    it "should use an existing connection if it exists" do
      XivelyConnector.disconnect
      XivelyConnector.connect(:api_key=>"abcdefg")
      expect {XivelyConnector::Device.find_by_id('000000001')}.not_to raise_error
    end

    it "should raise an error if a connection doesn't exists and no api_key is provided" do
      XivelyConnector.disconnect
      expect {XivelyConnector::Device.find_by_id('000000001')}.to raise_error
    end

  end

end

