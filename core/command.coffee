spwny   = require '../lib/spwny'
commons = require '../lib/commons'

exports.args =
  cmd : [ 'c', 'Command to execute', 'string' ]

pipeModules = (stream, modules = []) ->
  return commons.die 'piping failed' unless stream?
  module.pipe? stream for module in modules

exports.init = (args, { cmd } = {}, { modules } = {}) ->
  return commons.die 'command must be defined' unless cmd
  stream = spwny.invoke cmd
  pipeModules stream, modules
