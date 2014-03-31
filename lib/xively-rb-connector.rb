module XivelyConnector

  # Base XivelyConnector exception class
  class XivelyConnectorError < ::Exception; end

  # Module level methods for establishing connections and finding objects
  @@connection = nil

  # Lookup methods delegate to class methods
  def self.connection
    @@connection
  end

  # Lookup methods delegate to class methods
  def self.connect(options)
    raise "A connection can not be established without an :api_key" unless options[:api_key]
    @@connection = Connection.new(options)
  end

  # Releases the connection
  def self.disconnect()
    @@connection = nil
  end

  # Lookup method delegates to class methods
  def self.find(id, api_key=nil)
    self.find_device_by_id(id, api_key=nil)
  end

  # Lookup methods delegate to class methods
  def self.find_device_by_id(id, api_key=nil)
    self.connect(:api_key => api_key) unless api_key.nil?
    raise "Can not connect without an api_key or an existing connection." if self.connection.nil? and api_key.nil?
    Device.find_by_id(id)
  end

end

require "xively-rb-connector/version"
require "xively-rb-connector/logging"
require "xively-rb-connector/connection"
require "xively-rb-connector/device"
require "xively-rb-connector/datastream"