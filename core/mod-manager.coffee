_ = require 'lodash'

exports.priority = 0

exports.args =
  exclude : [ 'x', 'Excludes modules from loading', 'string' ]

getModules = (mods = '') ->
  return mods if Array.isArray mods
  mods.split ','

exports.init = (args, { exclude } = {}, { modules, config } = {}) ->
  excludeList = getModules exclude or config?.exclude
  return if not Array.isArray(modules) or not Array.isArray(excludeList)

  # Remove each mdoule from modules list if it happens to be in excluded list
  # Make sure that the array keeps the reference
  _.forEachRight modules, (mod) ->
    return unless mod.name?.trim() in excludeList
    modules.splice modules.indexOf(mod), 1
