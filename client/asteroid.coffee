Session.set 'counter', 0

Template.hello.helpers
  counter: ->
    return Session.get 'counter'

  'click button': ->
    # increment the counter when button is clicked
    Session.set 'counter', Session.get('counter') + 1
