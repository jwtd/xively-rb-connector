xively-rb-connector
===================

xively-rb-connector is a ruby gem that provides an interface to [Xively](https://xively.com). It extends Sam Mulube's
excellent [xively-rb](https://github.com/xively/xively-rb) gem. This gem adds convenience functions such as find_by_id
lookup functions, datastream compression (only saves datapoints when value changes), a datapoint recording buffer, etc.

[Xively](https://xively.com/whats_xively/) is a public cloud specifically built for the "Internet of Things". With their
platform, developers can connect physical devices, that produce one or more datastreams, to a managed data store. The
device's details and datastreams are accessible via key-based access to any service or application that has access to the
web. Xively provides a fantastic development portal and prototyping accounts are free.

## Requirements

* Ruby 1.9.3 or higher
* A [Xively account](https://xively.com/signup)

## Contact, feedback and bugs

Please file bugs / issues and feature requests on the [issue tracker](https://github.com/jwtd/xively-rb-connector/issues)

## Install

```
gem install xively-rb-connector
```

## Examples

```ruby

require 'xively-rb-connector'

# Xively provides a master api-key and device specific keys. To my knowledge, either can be used here.
my_api_key = 'XIVELY-ACCOUNT-OR-DEVICE-API-KEY-HERE'

# Each device on Xively gets thier own ID, which is exposed via thier REST API as a "feed"
feed_id = '123456789'

# Find your device on Xively by its feed_id
d = XivelyConnector.find_device_by_id(feed_id, my_api_key)

# Access details about the device
d.id	                # 123456789
d.feed	                # https://api.xively.com/v2/feeds/123456789.json
d.auto_feed_url         # https://api.xively.com/v2/feeds/123456789.json

d.title                 # My Meter
d.device_serial         # FOOBAR123456
d.description           # The xively on xively.com
d.tags                  # ["Gas", "Power", "Propane", "Water"]
d.creator               # https://xively.com/users/foo
d.email                 # your.email@gmail.com
d.website               # http://www.your-website.com
d.icon

d.created               # 2014-01-01 16:36:30 UTC
d.updated               # 2014-03-31 05:02:25 UTC
d.private               # true
d.is_private?           # true
d.status                # live
d.is_frozen?            # false

# Access location data directly
d.has_location?         # true
d.location_name         # The location name on xively.com
d.location_domain       # physical
d.location_lon          # -78.12343456
d.location_lat          # 35.12343454
d.location_ele          # 354 feet
d.location_exposure
d.location_disposition
d.location_waypoints

# Or get a structure that has all the location details
l = d.location          #<OpenStruct name="The location name on xively.com", latitude=35.12343454, longitude=-78.12343456, elevation="354 feet", exposure=nil, disposition=nil, waypoints=nil, domain="physical">
l.name                  # The location name on xively.com
l.domain                # physical
l.longitude             # -78.12343456
l.latitude              # 35.12343454
l.elevation             # 354 feet
l.exposure
l.disposition
l.waypoints

# Examine datastreams
d.datastream_ids          # ["Amperage", "Propane", "Voltage", "Power", "Well"]
d.datastream_values       # ["Amperage in Amps (A) = 0", "Propane in Cubic Feet (cft) = 0", "Voltage in Volts (V) = 9", "Power in Watts (W) = 0", "Well in Cubic Feet (cft) = 0"]
d.has_channel?('Voltage') # true

# Access datastreams by channel name using bracket syntax
d['Voltage']                # <XivelyConnector::Datastream:0x007ff62a137b80>
d['Voltage'].current_value  # 9

ds = d['Volts']
ds.id                       # Voltage
ds.unit_label               # Volts
ds.unit_symbol              # V
ds.current_value            # 9
ds.tags                     # Power
ds.min_value                # 0.0
ds.max_value                # 25.0

# Setup my datastream buffer
ds.only_save_changes = true    # Will only queue a datapoint if its value is different from the previous datapoint's which is also the current_value
ds.datapoint_buffer_size = 60  # Will auto-save to feed when 60 points are queued
ds.only_save_changes           # true
ds.only_saves_changes?         # true
ds.datapoint_buffer_size       # 60

# Queue new datapoints in a number of ways using the shift operator
# BigDecimal is used for value comparison so "10" == 10 == 10.0

ds.datapoints.size          # 0
ds << Xively::Datapoint.new(:value => "10", :at => Time.now,())
ds << {:at=>':at => Time.now(), :value => "10"}
ds << "10"
ds << 10
ds << 10.0
ds << 11

# If ds.only_save_changes is true, the commands above only result in two datapoints being queued (because the only unique values recorded were 10 and 11)
ds.datapoints.size          # 2

# Save datapoints to xively.com
ds.save_datapoints
ds.datapoints.size          # 0

```

## Resources

* [Free Xively Developer Account](https://xively.com/signup)
* [xively-rb](https://github.com/xively/xively-rb)
* [xively-js](http://xively.github.io/xively-js) is a javascript lib for viewing and charting Xively data

## Special Thanks

* Xively - for an awesome data platform
* Sam Mulube - for xively-rb
* Ian Duggan - for introducing me to ruby

