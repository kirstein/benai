#!/usr/bin/env coffee
LIB_DIR  = "#{__dirname}/../lib"

path   = require 'path'
pck    = require '../package.json'
mod    = require path.resolve "#{LIB_DIR}/modules"
cli    = require 'cli'
pubsub = require 'pubsub-js'

# CLI setup
cli.enable 'glob', 'help', 'version'
cli.setApp pck.name, pck.version

# Load the core and normal modules
core    = mod.load path.resolve "#{__dirname}/../core"
modules = mod.load path.resolve "#{__dirname}/../modules"

# Parse the arguments
# Add the arguments from the modules to the args listing, making them available for later usage
cli.parse mod.getArgs core, modules


# Initialize all modules
# We ignore the bin location and start our arguments from the second argument
cli.main ([binLoc, args...], options) ->
  opts =
    modules : modules
    events  : pubsub

  initArgs = [
    args
    options # Cli option
    opts    # Custom added options
  ]


  # Invoke core modules first. They have the power to override modules if needed
  mod.init [ core ], initArgs...

  # Build the extended options for modules
  mod.mixinOptions core, opts
  mod.init [ modules ], initArgs...
