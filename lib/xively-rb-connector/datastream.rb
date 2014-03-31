require 'xively-rb'
require 'json'
require 'bigdecimal'

module XivelyConnector

  # Extend https://github.com/xively-rb-connector/xively-rb
  class Datastream < Xively::Datastream

    attr_reader :device
    attr :datapoint_buffer_size, :only_save_changes

    # Mix in the ability to log
    include XivelyConnector::Logging

    def initialize(options)
      @logger = options[:logger] || logger
      @logger.debug "XivelyConnector::Datastream initialize"

      raise "An instance of XivelyConnector::Device must be provided to create a datastream" unless options[:device]
      raise "The data block for this datastream is missing" unless options[:data]

      # Capture parent and initialize Xively::Datastream
      @device = options[:device]
      data   = options[:data]
      super(data)

      # Set the default buffer size (1 reading per minute)
      @datapoint_buffer_size = options[:datapoint_buffer_size] || 60
      @only_save_changes = options[:only_save_changes] || true

      # Initialize Xively::Datastream's datapoint array to allow shift style loading
      @datapoints = []

      # Fix the unit attribute assignments
      @unit_symbol   = data['unit']['symbol']
      @unit_label    = data['unit']['label']

      # Cast the current value as a BigDecimal for casting strings and comparing to ints and floats
      @current_value = 0 if current_value.nil?

      @logger.info "Initialized Datastream #{@id} (#{@unit_symbol})"

    end

    def only_saves_changes?
      only_save_changes
    end

    # Have shift operator load the datapoint into the datastream's datapoints array
    # If only_save_changes is true, ignore datapoints whose value is the same as the current value
    # If the datapoints array has exceeded the datapoint_buffer_size, send them to Xively
    def <<(datapoint)
      if only_save_changes and BigDecimal.new(datapoint.value) == BigDecimal.new(current_value)
        @logger.debug "Ignoring datapoint from #{datapoint.at} because value did not change from #{current_value}"
      else
        @current_value = datapoint.value
        datapoints << datapoint
        @logger.debug "Queuing datapoint from #{datapoint.at} with value #{current_value}"
      end
      save_datapoints if datapoints.size >= @datapoint_buffer_size
    end

    # Send the queued datapoints array to Xively
    def save_datapoints
      @logger.debug "Saving #{datapoints.size} datapoints to the #{id} datastream"
      response = XivelyConnector.connection.post("/v2/feeds/#{device.id}/datastreams/#{id}/datapoints",
                                                  :body => {:datapoints => datapoints}.to_json)
      if response.success?
        clear_datapoints
        response
      else
        logger.error response.response
        raise response.response
      end
    end

    # Resets the datapoints
    def clear_datapoints
      @datapoints = []
    end

  end
end
