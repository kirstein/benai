spwny   = require '../../lib/spwny'
commons = require '../../lib/commons'
mod     = require '../../lib/modules'

module.exports = class Command
  constructor: (@rawCommand, modules = []) ->
    @modules = mod.sortModulesByPriority modules
    @run()

  run: ->
    @stream = spwny.invoke @rawCommand
    @buildPipes()
    @stream

  buildPipes: ->
    return commons.die 'piping failed' unless @stream?
    @stream = module.pipe @stream for module in @modules when module.pipe?
