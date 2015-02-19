#Meteor.call 'getLights', (err, lights) ->
#  Session.get

Template.panel.helpers
  template: -> if Session.get('object')
    Session.get('object').split(':')[0] + 'Panel'

Template.huePanel.rendered = ->
  @autorun ->
    if Session.get 'object'
      Meteor.call 'get state', Session.get('object'), (err, state) ->
        state.bri = 0 unless state.on
        Session.set 'state', state

Template.huePanel.helpers
  state: -> Session.get 'state'
  rgb: (focus) ->
    state = Session.get 'state'
    "hsla(#{Math.round(state.hue * 360 / 65535)}, #{if focus is 'sat' then state.sat else 100}%, #{if focus is 'bri' then state.bri/2 else 50}%, 1)"

Template.huePanel.events
  'change paper-slider': (evt) ->
    state =
      hue: $('#hue')[0].value
      sat: $('#sat')[0].value
      bri: $('#bri')[0].value
      colormore: 'hs'
    state.on = state.bri > 0

    Session.set 'state', state
    Meteor.call 'set state', Session.get('object'), state

Template.objects.events
  'core-activate core-selector': (evt) ->
    Session.set 'object', evt.target.selected
    Session.set 'state', {}
