command = require "#{process.cwd()}/core/command"
spwny   = require "#{process.cwd()}/lib/spwny"
stream  = require 'stream'
sinon   = require 'sinon'

describe 'command', ->

  describe 'args', ->
    it 'should have cmd arg', -> command.args.cmd.should.be.ok

  describe '#init', ->
    it 'should exist', -> command.init.should.be.ok

    it 'should die with code 1 if there is no command', sinon.test ->
      @stub process, 'exit'
      command.init null, null, null
      process.exit.calledWith(1).should.be.ok

    it 'should call spwny invoke with the command', sinon.test ->
      @stub(spwny, 'invoke').returns stream.PassThrough()
      command.init null, cmd: 'test', null
      spwny.invoke.calledWith('test').should.be.ok

    it 'should die if spwny returns no stream', sinon.test ->
      @stub spwny, 'invoke'
      @stub process, 'exit'
      command.init null, cmd: 'test', null
      process.exit.calledWith(1).should.be.ok

    it 'should trigger #pipe on each given module', sinon.test ->
      initSpy           = sinon.spy()
      passThroughStream = stream.PassThrough()
      @stub(spwny, 'invoke').returns passThroughStream
      command.init null, { cmd: 'test' }, modules : [ pipe : initSpy ]
      initSpy.calledWith(passThroughStream).should.be.ok
