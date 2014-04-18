commons = require '../lib/commons'
through = require 'through'

exports.name = 'parser'

exports.pipe = (stream) =>
  self = @
  return stream unless @parserFn
  stream.pipe through (data) ->
    return unless parsed = self.parserFn data
    @queue parsed

exports.init = (args, opts, { config } = {}) ->
  @parserFn = config.parser
