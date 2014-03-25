path = require 'path'
fs   = require 'fs'

CONFIG_NAME = 'benai.conf.js'

buildConfigUrl = ->
  path.join process.cwd(), CONFIG_NAME

exports.load = false

exports.args =
  config : [ false, 'Configuration file to read', 'string' ]

exports.init = (args, { config } = {}) =>
  config or= buildConfigUrl()
  @loadConfigs config if fs.existsSync config

exports.loadConfigs = (configUrl) -> require(configUrl)?.config()
