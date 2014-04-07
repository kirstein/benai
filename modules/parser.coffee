commons = require '../lib/commons'
through = require 'through'

exports.name = 'parser'
exports.args =
  regexp : [ 'r', 'Regexp to parse', 'string' ]

exports.pipe = (stream) =>
  self = @
  return stream unless @parser
  stream.pipe through (data) -> @queue self.parser data

exports.init = (args, opts, { config } = {}) ->
  @parser = config.parser

