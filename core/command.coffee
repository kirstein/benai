spwny = require '../lib/spwny'

# Kill the process with text and status code
die = (text, code = 1) ->
  process.stdout.write text if text
  process.exit code

exports.args =
  'cmd' : [ 'c', 'Command to execute', 'string' ]

pipeModules = (stream, modules) ->
  die 'piping failed' unless stream?
  stream.pipe process.stdout

exports.init = (args, { cmd }, { modules }) ->
  die 'command must be defined' unless cmd
  stream = spwny.invoke cmd
  pipeModules stream, modules
