commons = require '../lib/commons'
through = require 'through'

exports.name = 'parser'

exports.pipe = (stream) =>
  self = @
  return stream unless @parserFn
  stream.pipe through (data) -> @queue self.parserFn data

exports.init = (args, opts, { config } = {}) ->
  @parserFn = config.parser

