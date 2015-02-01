Session.setDefault 'light', -1

Meteor.call 'getLights', (err, lights) ->
  Session.get

Template.hello.helpers
  counter: ->
    return Session.get 'counter'

  'click button': ->
    # increment the counter when button is clicked
    Session.set 'counter', Session.get('counter') + 1
