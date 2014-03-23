exports.priority = 0

exports.args =
  exclude : [ 'x', 'Excludes modules from loading', 'string' ]

exports.init = (args, { exclude } = {}, { modules } = {}) ->
  return if not exclude or not Array.isArray modules
  excludeList = exclude.split ','

  # Remove each mdoule from modules list if it happens to be in excluded list
  # Make sure that the array keeps the reference
  for mod in modules by -1 when mod?.name?
    name = mod.name.trim()
    return if not name or name not in excludeList
    modules.splice modules.indexOf(mod), 1
