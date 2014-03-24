keypress = require 'keypress'

exports.name = 'keypress'

exports.args =
  runOnce : [ false, 'Do not watch for events' ]

exports.bindEvents = (events) ->
  # When ctrl+c is pressed then quit the process
  events.subscribe 'keypress:ctrl:c', -> process.stdin.pause()

# Builds the event name of the keyEvent object
# Event name has its modifier keys and the event name as first item
# Example:
#   name: r
#   ctrl: true
#
# will reproduce
#   'keypress:ctrl:r'
exports.getEventName = (keyEvent) ->
  event     = "keypress"
  modifiers = [ 'meta', 'ctrl', 'shift' ]

  # Build the string
  event += ":#{key}" for key in modifiers when keyEvent[key] is true
  "#{event}:#{keyEvent.name}"

exports.startListening = (events) =>
  keypress process.stdin
  process.stdin.setRawMode true
  process.stdin.resume()

  # Watch for all keypress events
  # if keypress events happen then trigger them publish them via events
  process.stdin.on 'keypress', (ch, key) =>
    return unless key or key.name?
    events.publish @getEventName key

exports.init = (args, { runOnce } = {}, { events } = {}) ->
  return if runOnce
  @bindEvents events
  @startListening events
