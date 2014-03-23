# Kill the process with text and status code
exports.die = (text, code = 1) ->
  process.stdout.write text if text
  process.exit code
