spwny   = require '../../lib/spwny'
commons = require '../../lib/commons'

module.exports = class Command
  constructor: (@rawCommand, @modules = []) -> @run()

  run: ->
    @stream = spwny.invoke @rawCommand
    @buildPipes()
    @stream

  buildPipes: ->
    return commons.die 'piping failed' unless @stream?
    module.pipe? @stream for module in @modules
