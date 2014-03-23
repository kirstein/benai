keypress = require 'keypress'

exports.name = "keypress"

exports.args =
  runOnce : [ false, 'Do not watch for events' ]

exports.init = (args, { runOnce } = {}, { events } = {}) ->
  return if runOnce
  keypress process.stdin
  process.stdin.setRawMode true
  process.stdin.resume()

  # Watch for all keypress events
  # if keypress events happen then trigger them publish them via events
  process.stdin.on 'keypress', (ch, key) ->
    return unless key or key.name?
    # When ctrl+c is pressed then quit the process
    return process.stdin.pause() if key.ctrl && key.name is 'c'
    events.publish "keypress:#{key.name}"

