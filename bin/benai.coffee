#!/usr/bin/env coffee
cli = require('cli').enable 'glob', 'help'
mod = require "#{__dirname}/../lib/modules"

modules = mod.load "#{__dirname}/../modules"
cli.parse mod.getArgs modules
console.log mod.getArgs modules
