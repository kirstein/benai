fs   = require 'fs'
path = require 'path'
_    = require 'lodash'

# Gets the directory, fetches its content and requires all files from that directory.
# Returned modules will be required and mapped.
exports.load = (dir) ->
  _.map fs.readdirSync(dir), (mod) -> require path.join dir, mod

# Fetches all the arguments from given modules
#
# There can be unlimited number of given arguments, the arguments array will be flattened.
# There will be no warning if the arguments overlap.
exports.getArgs = ->
  _(arguments).flatten()
              .filter 'args'
              .reduce ( (old, mod) -> _.extend old, mod.args ), {}

# Triggers init method on all given modules
# passes the arguments to the module
exports.init = (modules = [], args...)->
  mods = _(@sortModulesByPriority modules).flatten()
            .filter 'init'
            .invoke 'init', args...

exports.sortModulesByPriority = (modules = []) ->
  _.sortBy modules, (mod) ->
    return 1 unless mod?.priority?
    mod.priority

