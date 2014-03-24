child_process     = require 'child_process'
DuplexPassthrough = require 'duplex-passthrough'

buildCmdArray = (cmd) ->
  args = cmd.split ' '
  args = args.filter (arg) -> arg
  [ args[0], args[1..] ]

spawnPipes = (cmds, Stream = DuplexPassthrough) ->
  oldProc = null

  # Pipe streams together, starting from the last
  for rawCmd in cmds
    newProc = child_process.spawn buildCmdArray(rawCmd)...
    oldProc.stdout?.pipe newProc.stdin if oldProc
    oldProc = newProc

  new Stream oldProc.stdout

# Invoke the target command and start piping the data
exports.invoke = (cmd, stream) ->
  throw new Error 'No command defined' unless cmd
  spawnPipes cmd.split('|'), stream
