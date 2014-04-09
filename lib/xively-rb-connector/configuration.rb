module XivelyConnector

  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  class Configuration
    attr_accessor :api_key
    attr_accessor :datapoint_buffer_size
    attr_accessor :only_save_changes
  end

end