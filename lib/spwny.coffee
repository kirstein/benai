spawn  = require('child_process').spawn
stream = require 'stream'

buildCmdArray = (cmd) ->
  args = cmd.split ' '
  args = args.filter (arg) -> arg
  [ args[0], args[1..] ]

spawnPipes = (cmds) ->
  stream  = stream.PassThrough()
  oldProc = null

  # Pipe streams together, starting from the last
  for rawCmd in cmds
    newProc = spawn buildCmdArray(rawCmd)...
    newProc.on 'error', (err) -> stream.emit 'error', err
    oldProc.stdout.pipe newProc.stdin if oldProc
    oldProc = newProc

  oldProc.stdout.pipe stream
  stream

# Invoke the target command and start piping the data
exports.invoke = (cmd) ->
  spawnPipes cmd.split '|'
