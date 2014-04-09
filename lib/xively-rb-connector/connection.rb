require 'xively-rb'

module XivelyConnector

  class Connection < Xively::Client

    format :json

    # Mix in the ability to log
    include Logger

    attr_accessor :config

    def initialize(options)
      @logger = options[:logger] || logger
      #@config = options[:config] || Configuration.new
      @logger.debug "XivelyConnector::Connection initialize"
      super(options[:api_key])
    end


    #Set HTTParty params that we need to set after initialize is called
    #These params come from @options within initialize and include the following:
    #:ssl_ca_file - SSL CA File for SSL connections
    #:format - 'json', 'xml', 'html', etc. || Defaults to 'xml'
    #:format_header - :format Header string || Defaults to 'application/xml'
    #:pem_cert - /path/to/a/pem_formatted_certificate.pem for SSL connections
    #:pem_cert_pass - plaintext password, not recommended!
    def set_httparty_options(options={})
      if options[:ssl_ca_file]
        ssl_ca_file opts[:ssl_ca_file]
        if options[:pem_cert_pass]
          pem File.read(options[:pem_cert]), options[:pem_cert_pass]
        else
          pem File.read(options[:pem_cert])
        end
      end
    end

  end

end
