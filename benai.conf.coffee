exports.config = ->
  command: 'ls -la'
  parser: (data) ->
    data.toString().toUpperCase()
  exclude: []
