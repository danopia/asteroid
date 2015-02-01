bridge = null

Meteor.startup ->
  response = HTTP.get 'https://www.meethue.com/api/nupnp'
  for bridge in response.data
    device = Devices.findOne module: 'hue', id: bridge.id
    if device
      console.log 'Found Hue pairing'
      return

    console.log 'Press the pairing button on your Hue bridge, called', bridge.name
    interval = Meteor.setInterval ->
      userResponse = HTTP.post "http://#{bridge.internalipaddress}/api", data:
        devicetype: "asteroid##{Npm.require('os').hostname()}"

      if userResponse.data[0].success
        Meteor.clearInterval interval
        console.log 'Paired to Hue bridge'

        bridge.secret = userResponse.data[0].success.username
        bridge.module = 'hue'
        Devices.upsert { id: bridge.id }, $set: bridge
    , 5000

Meteor.methods
  'list devices': (module) ->
    Devices.find module: module

  'list objects': (path) ->
    parts = path.split ':'
    device = Devices.findOne module: parts[0], id: parts[1]
    return [] unless device

    if device.module is 'hue'
      HTTP.get("#{device.url}/lights").data
    else
      []

  'get meta': (path) ->
    parts = path.split ':'
    device = Devices.findOne module: parts[0], id: parts[1]
    return [] unless device

    if device.module is 'hue'
      HTTP.get("#{device.url}/lights/#{parts[2]}").data

  'get state': (path) ->
    parts = path.split ':'
    device = Devices.findOne module: parts[0], id: parts[1]
    return [] unless device

    if device.module is 'hue'
      HTTP.get("#{device.url}/lights/#{parts[2]}").data.state

  'set state': (path, state) ->
    parts = path.split ':'
    device = Devices.findOne module: parts[0], id: parts[1]
    return [] unless device
    @unblock()

    if device.module is 'hue'
      HTTP.put("#{device.url}/lights/#{parts[2]}/state", data: state).data
