module XivelyConnector

  def self.version_string
    "XivelyConnector version #{XivelyConnector::VERSION::STRING}"
  end

  module VERSION #:nodoc:
    MAJOR = 0
    MINOR = 1
    PATCH = 3

    STRING = [MAJOR, MINOR, PATCH].join('.')
  end
end
