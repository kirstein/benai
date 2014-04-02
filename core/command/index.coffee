Command = require './command'
commons = require '../../lib/commons'

exports.args =
  cmd : [ 'c', 'Command to execute', 'string' ]

exports.bindEvents = (events) =>
  events.subscribe 'keypress:r', => @command.run()

exports.init = (args, { cmd } = {}, { modules, events, config } = {}) =>
  triggerCmd = cmd or config?.command
  return commons.die 'command must be defined' unless triggerCmd
  @bindEvents events
  @command = new Command triggerCmd, modules
