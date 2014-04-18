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

  # for each module in modules list
  # pipe its output to next one unless the old one returns null or undefined
  buildPipes: ->
    return commons.die 'piping failed' unless @stream?
    for module in @modules when module.pipe?
      tmp = module.pipe @stream
      # assure that all the piping functions return something
      @stream = tmp if tmp?
