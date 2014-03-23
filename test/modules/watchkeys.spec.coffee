sinon     = require 'sinon'
watchkeys = require "#{process.cwd()}/modules/watchkeys"

describe 'watchkeys', ->
  describe '#args', ->
    it 'should have runOnce arg', -> watchkeys.args.runOnce.should.be.ok

  describe '#init', ->
    it 'should not start watching if runOnce is passed', sinon.test ->
      @stub process.stdin, 'on'
      watchkeys.init null, { runOnce: true }, null
      process.stdin.on.called.should.not.be.ok
