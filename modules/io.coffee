exports.name = 'io'
exports.description = 'pipes output to io'

# IO is always the last one to run!
exports.priority = 9999

exports.pipe = (stream) ->
  stream.pipe process.stdout
