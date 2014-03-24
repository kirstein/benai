cp     = require 'child_process'
stream = require 'stream'

buildCmdArray = (cmd) ->
  args = cmd.split ' '
  args = args.filter (arg) -> arg
  [ args[0], args[1..] ]

spawnPipes = (cmds, res = stream.PassThrough()) ->
  oldProc = null

  # Pipe streams together, starting from the last
  for rawCmd in cmds
    newProc = cp.spawn buildCmdArray(rawCmd)...
    newProc.on 'error', (err) -> stream.emit 'error', err
    oldProc.stdout.pipe newProc.stdin if oldProc
    oldProc = newProc

  oldProc.stdout.pipe res
  res

# Invoke the target command and start piping the data
exports.invoke = (cmd, stream) ->
  throw new Error 'No command defined' unless cmd
  spawnPipes cmd.split('|'), stream
