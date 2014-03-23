spwny = require '../lib/spwny'

# Kill the process with text and status code
die = (text, code = 1) ->
  process.stdout.write text if text
  process.exit code

exports.args =
  cmd : [ 'c', 'Command to execute', 'string' ]

pipeModules = (stream, modules = []) ->
  return die 'piping failed' unless stream?
  module.pipe? stream for module in modules

exports.init = (args, { cmd } = {}, { modules } = {}) ->
  return die 'command must be defined' unless cmd
  stream = spwny.invoke cmd
  pipeModules stream, modules
