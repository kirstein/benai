fs = require 'fs'
path = require 'path'
_ = require 'lodash'

exports.load = (dir) ->
  _.map fs.readdirSync(dir), (mod) -> require path.join dir, mod

exports.getArgs = (modules = []) ->
  _(modules).filter 'args'
            .reduce ( (old, mod) -> _.extend old, mod.args ), {}

