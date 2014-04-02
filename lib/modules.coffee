fs   = require 'fs'
path = require 'path'
_    = require 'lodash'

# Gets the directory, fetches its content and requires all files from that directory.
# Returned modules will be required and mapped.
exports.load = (dir) ->
  files = fs.readdirSync dir
  _.map files, (mod) -> require path.join dir, mod

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
  sortedModules = @sortModulesByPriority _.flatten modules
  _(sortedModules).filter 'init'
                  .invoke 'init', args...

# Sorts modules by their correct order
# if module has no priority consider it to have priority of 1
exports.sortModulesByPriority = (modules = []) ->
  _.sortBy modules, (mod) ->
    return 1 unless mod?.priority?
    mod.priority

# Checks if all the modules have options obj
# if they do then extend the current obj with the results of that fn
exports.mixinOptions = (modules = [], obj = {}) ->
  _.each modules, (mod) -> _.extend obj, mod.options?()
  obj
