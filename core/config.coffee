path = require 'path'
fs   = require 'fs'
_    = require 'lodash'

CONFIG_NAME = 'benai.conf'
CONFIG_SUFF = [ 'cs', 'coffee', 'js' ]

buildConfigUrl = (suffix) ->
  path.join process.cwd(), "#{CONFIG_NAME}.#{suffix}"

isRequireable = (file) ->
  return false unless file
  fs.existsSync file

exports.priority = 0

exports.args =
  config : [ false, 'Configuration file to read (if not present will search for benai.conf.(js|coffee|cs)', 'string' ]

# Searches for the current provided config
#
# if that config cannot be found then searches the current directory for the `benai.config`
# will try all acceptable benai config variants and if one of those works, then will return that config location
exports.findConfig = (config) ->
  return config if isRequireable config

  # Build the config name by trying all the suffixes
  for suffix in CONFIG_SUFF
    suffixedConf = buildConfigUrl suffix
    return suffixedConf if isRequireable suffixedConf

exports.init = (args, { config } = {}, opts = {}) =>
  return unless conf = @findConfig config
  opts.config = _.extend opts.config or {}, @loadConfigs conf

exports.loadConfigs = (configUrl) -> require(configUrl)?.config()
