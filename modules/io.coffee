exports.name = 'io'
exports.description = 'pipes output to io'

exports.pipe = (stream) ->
  stream.pipe process.stdout
