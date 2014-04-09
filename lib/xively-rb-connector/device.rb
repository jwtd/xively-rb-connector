require 'xively-rb'
require 'json'
require 'ostruct'


module XivelyConnector

# Extend https://github.com/xively-rb-connector/xively-rb
class Device < Xively::Feed

    attr_reader :datapoint_buffer_size, :only_save_changes

    # Mix in the ability to log
    include Logger

    # Connect to a device by ID
    def self.find_by_id(id, options={})

      # First connect if necessary
      unless XivelyConnector.connected?
        raise XivelyConnectorError, "Can not connect without an api_key or an existing connection." unless options[:api_key]
        XivelyConnector.connect(options)
      end

      XivelyConnector.connection.logger.debug "Device.find_by_id(#{id})"

      # Perform the lookup  and add the response
      options[:response] = XivelyConnector.connection.get("/v2/feeds/#{id}.json")

      if options[:response].success?
        self.new(options)
      else
        logger.error options[:response].response
        options[:response].response
      end
    end

    # Converts the Xively dates to ruby DateTimnes and make the datastreams accessible via hash syntax
    def initialize(options)

      # Create logger
      @logger = options[:logger] || logger
      @logger.debug "XivelyConnector::Device initialize"

      # initialize parent
      data = options[:response]
      @datapoint_buffer_size = options[:datapoint_buffer_size] || 1
      @only_save_changes     = options[:only_save_changes] || false
      super(options[:response])

      # Convert date strings to ruby dates
      @created = Time.iso8601(created) # 2014-03-28T16:36:30.651731Z
      @updated = Time.iso8601(updated) # 2014-03-28T16:45:05.206472Z

      # xively-rb doesn't set location attributes correctly, so do so here
      if data['location']
        loc = data['location']
        @has_location    = true
        @location_name   = loc['name'] if
        @location_domain = loc['domain'] if loc['domain']
        @location_lon    = loc['lon'] if loc['lon']
        @location_lat    = loc['lat'] if loc['lat']
        @location_ele    = loc['ele'] if loc['ele']
        @location_exposure    = loc['exposure'] if loc['exposure']
        @location_disposition = loc['disposition'] if loc['disposition']
        @location_waypoints   = loc['waypoints'] if loc['waypoints']
      end

      # Setup enhanced datastreams
      @datastream_ref = {}
      datastreams.each { |ds| @datastream_ref[ds.id] = ds }

      @logger.info "Initialized Xively Device #{@id} with #{datastreams.size} datastreams"

    end

    # Support bracket notation for retriving data streams
    def [](channel_id)
      @datastream_ref[channel_id]
    end

    # Override the datastreams function so that it creates XivelyConnector::Datastreams which extend the standard one
    def datastreams=(array)
      return unless array.is_a?(Array)
      @datastreams = []
      array.each do |datastream|
        if datastream.is_a?(Datastream)
          @datastreams << datastream
        elsif datastream.is_a?(Hash)
          #@datastreams << Datastream.new(datastream)
          @datastreams << XivelyConnector::Datastream.new(:device => self,
                                                          :data => datastream,
                                                          :datapoint_buffer_size => datapoint_buffer_size,
                                                          :only_save_changes => only_save_changes)
        end
      end
    end

    # Returns an array of datastream ids which are present on this device
    def datastream_ids
      @datastream_ref.keys
    end

    def datastream_values
      v = []
      @datastream_ref.each do |id, ds|
        v << "#{id} in #{ds.unit_label} (#{ds.unit_symbol}) = #{ds.current_value}"
      end
      v
    end

    def has_datastream?(channel)
      @datastream_ref.has_key?(channel)
    end

    def has_channel?(channel)
      has_datastream?(channel)
    end

    def is_private?
      private == 'true'
    end

    def is_frozen?
      status == 'frozen'
    end

    def has_location?
      @has_location ||= false
    end

    def location
      @location ||= OpenStruct.new(
        :name        => location_name,
        :latitude    => location_lat,
        :longitude   => location_lon,
        :elevation   => location_ele,
        :exposure    => location_exposure,
        :disposition => location_disposition,
        :waypoints   => location_waypoints,
        :domain      => location_domain
      )
    end

  end

end
