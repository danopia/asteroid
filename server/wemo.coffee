WeMo = Meteor.npmRequire 'wemo'

Meteor.methods
  'get state/wemo': (device, port) ->
    object = new WeMo device, +port
    Async.wrap(object, 'getBinaryState')() is '1'

  'set state/wemo': (device, port, state) ->
    object = new WeMo device, +port
    ret = Async.wrap(object, 'setBinaryState')(+state)
    console.log 'set', ret
