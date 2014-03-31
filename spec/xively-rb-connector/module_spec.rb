require 'spec_helper'

describe XivelyConnector do

  it 'should return correct version string' do
    XivelyConnector.version_string.should == "XivelyConnector version #{XivelyConnector::VERSION::STRING}"
  end

  describe ".connection" do

    it "should be available from the module" do
      XivelyConnector.connect(:api_key=>"abcdefg")
      XivelyConnector.connection.class.should == XivelyConnector::Connection
      XivelyConnector.connection.api_key.should == 'abcdefg'
    end

  end

  describe ".connect" do

    it "should connect using an api-key" do
      XivelyConnector.connect(:api_key=>'abcdefg').api_key.should == 'abcdefg'
      XivelyConnector.connection.class.should == XivelyConnector::Connection
      XivelyConnector.connection.api_key.should == 'abcdefg'
    end

  end

  describe ".disconnect" do

    it "should release the connection" do
      XivelyConnector.connect(:api_key=>"abcdefg")
      XivelyConnector.disconnect
      XivelyConnector.connection.should == nil
    end

  end

  describe ".find" do

    it "should use an existing connection if it exists" do
      XivelyConnector.disconnect
      XivelyConnector.connect(:api_key=>"abcdefg")
      expect {XivelyConnector.find('000000001')}.not_to raise_error
    end

    it "should raise an error if a connection doesn't exists and no api_key is provided" do
      XivelyConnector.disconnect
      expect {XivelyConnector.find('000000001')}.to raise_error
    end

  end


  describe ".find_device_by_id" do

    it "should use an existing connection if it exists" do
      XivelyConnector.disconnect
      XivelyConnector.connect(:api_key=>"abcdefg")
      expect {XivelyConnector.find('000000001')}.not_to raise_error
    end

    it "should raise an error if a connection doesn't exists and no api_key is provided" do
      XivelyConnector.disconnect
      expect {XivelyConnector.find('000000001')}.to raise_error
    end

  end


end
