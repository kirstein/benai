Command = require './command'
commons = require '../../lib/commons'

exports.args =
  cmd : [ 'c', 'Command to execute', 'string' ]

exports.bindEvents = (events) =>
  events.subscribe 'keypress:r', => @command.run()

exports.init = (args, { cmd } = {}, { modules, events } = {}) =>
  return commons.die 'command must be defined' unless cmd
  @bindEvents events
  @command = new Command cmd, modules
