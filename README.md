xively-rb-connector
===================

Ruby gem that provides an interface to Xively by extending xively-rb with convenience functions such Device.find_by_id, a datastream compression (only saves datapoints when value changes), a datapoint recording buffer, etc.


```ruby

require 'xively-rb-connector'

d = XivelyConnector.find_device_by_id('123456789', 'ACCOUNT-OR-DEVICE-API-KEY-HERE')

d.id	                # 123456789
d.feed	                # https://api.xively.com/v2/feeds/123456789.json
d.auto_feed_url         # https://api.xively.com/v2/feeds/123456789.json

d.title                 # My Meter
d.device_serial:        # FOOBAR123456
d.description           # The xively on xively.com
d.tags                  # ["Gas", "Power", "Propane", "Water"]
d.creator               # https://xively.com/users/foo
d.email                 # your.email@gmail.com
d.website               # http://www.your-website.com
d.icon:

d.created               # 2014-01-01 16:36:30 UTC
d.updated               # 2014-03-31 05:02:25 UTC
d.private               # true
d.is_private?           # true
d.status                # live
d.is_frozen?            # false

# Access location data
d.has_location?         # true
d.location              #<OpenStruct name="6004 Bedfordshire Dr, Raleigh NC", latitude=35.7069733120845, longitude=-78.7572026183472, elevation="354 feet", exposure=nil, disposition=nil, waypoints=nil, domain="physical">
d.location_name         # The location name on
d.location_domain       # physical
d.location_lon          # -78.12343456
d.location_lat          # 35.12343454
d.location_ele          # 354 feet
d.location_exposure
d.location_disposition
d.location_waypoints

# Examine datastreams
d.datastream_ids        ["Amps", "Propane", "Volts", "Watts", "Well"]
d.datastream_values:    ["Amps in Amps (A) = 0", "Propane in Cubic Feet (cft) = 0", "Volts in Volts (V) = 9", "Watts in Watts (W) = 0", "Well in Cubic Feet (cft) = 0"]
d.has_channel?('Volts') true

# Access datastreams by channel name
d['Volts']                  #<XivelyConnector::Datastream:0x007ff62a137b80>
d['Volts'].current_value    9
ds = d['Volts']
ds.id                       Volts
ds.current_value            9
ds.tags                     Power
ds.min_value                0.0
ds.max_value                25.0
ds.unit_label               Volts
ds.unit_symbol              V

# Queue new datapoints using the shift operator
ds.datapoints.size          0
ds << Xively::Datapoint.new(:at => Time.now(), :value => "10")
ds << Xively::Datapoint.new(:at => Time.now(), :value => "15")
ds << Xively::Datapoint.new(:at => Time.now(), :value => "25")
ds.datapoints.size          3

# Save datapoints to xively.com
ds.only_saves_changes?      true  # Will only queue a datapoint if its value is different from the previous datapoint's which is also the current_value
ds.datapoint_buffer_size    60    # Will auto-save to feed when 60 points are added
ds.save_datapoints
ds.datapoints.size          0

```