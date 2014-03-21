#!/usr/bin/env coffee
LIB_DIR  = "#{__dirname}/../lib"

pck   = require '../package.json'
mod   = require "#{LIB_DIR}/modules"
_     = require 'lodash'
cli   = require 'cli'

# Setup cli
cli.enable 'glob', 'help', 'version'
cli.setApp pck.name, pck.version

# Load the core and normal modules
core    = mod.load "#{__dirname}/../core"
modules = mod.load "#{__dirname}/../modules"

# Parse the arguments
# Add the arguments from the modules to the args listing, making them available for later usage
cli.parse mod.getArgs core, modules

# Initialize
# We ignore the bin location and start our arguments from the second argument
cli.main ([binLoc, args...], options) ->
  mod.init [ core, modules ], args, options
