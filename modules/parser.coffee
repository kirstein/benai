commons = require '../lib/commons'
through = require 'through'

exports.name = 'parser'
exports.args =
  regexp : [ 'r', 'Regexp to parse', 'string' ]

exports.pipe = (stream) =>
  #return unless @regexp
  self = @
  stream.pipe through (data) -> @queue data.toString().toUpperCase()

exports.init = (args, { @regexp } = {}) ->

