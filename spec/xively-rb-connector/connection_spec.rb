require 'spec_helper'

describe XivelyConnector::Connection do

  before do
    @client = XivelyConnector.connect(:api_key => "abcdefg")
  end

  it "should have the base uri defined" do
    XivelyConnector::Connection.base_uri.should == 'https://api.xively.com'
  end

  describe "#get" do
    it "should make the appropriate request" do
      request_stub = stub_request(:get, "#{XivelyConnector::Connection.base_uri}/v2/feeds/504.json").
          with(:headers => {'User-Agent' => XivelyConnector::Connection.user_agent, 'X-ApiKey' => 'abcdefg'})
      @client.get('/v2/feeds/504.json')
      request_stub.should have_been_made
    end
  end

  describe "#put" do
    it "should make the appropriate request" do
      request_stub = stub_request(:put, "#{XivelyConnector::Connection.base_uri}/v2/feeds/504.json").
          with(:headers => {'User-Agent' => XivelyConnector::Connection.user_agent, 'X-ApiKey' => 'abcdefg'}, :body => "dataz")
      @client.put('/v2/feeds/504.json', :body => "dataz")
      request_stub.should have_been_made
    end
  end

  describe "#post" do
    it "should make the appropriate request" do
      request_stub = stub_request(:post, "#{XivelyConnector::Connection.base_uri}/v2/feeds/504.json").
          with(:headers => {'User-Agent' => XivelyConnector::Connection.user_agent, 'X-ApiKey' => 'abcdefg'}, :body => "dataz")
      @client.post('/v2/feeds/504.json', :body => "dataz")
      request_stub.should have_been_made
    end
  end

  describe "#delete" do
    it "should make the appropriate request" do
      request_stub = stub_request(:delete, "#{XivelyConnector::Connection.base_uri}/v2/feeds/504/datastreams/test.json").
          with(:headers => {'User-Agent' => XivelyConnector::Connection.user_agent, 'X-ApiKey' => 'abcdefg'})
      @client.delete('/v2/feeds/504/datastreams/test.json')
      request_stub.should have_been_made
    end
  end

end


