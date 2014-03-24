command = require "#{process.cwd()}/core/command"
spwny   = require "#{process.cwd()}/lib/spwny"
stream  = require 'stream'
sinon   = require 'sinon'

describe 'command', ->

  describe 'args', ->
    it 'should have cmd arg', -> command.args.cmd.should.be.ok

  describe '#bindEvents', ->
    it 'should subscribe to keypress:r event', ->
      events = subscribe : sinon.spy()
      command.bindEvents events
      events.subscribe.calledWith 'keypress:r'

    it 'should trigger command run when keypress:r is triggered', ->
      events = subscribe : (evt, cb) -> cb()
      command.command = run : sinon.spy()
      command.bindEvents events
      command.command.run.called.should.be.ok

  describe '#init', ->
    it 'should exist', -> command.init.should.be.ok

    it 'should die with code 1 if there is no command', sinon.test ->
      @stub process, 'exit'
      command.init null, null, null
      process.exit.calledWith(1).should.be.ok

    it 'should call spwny invoke with the command', sinon.test ->
      @stub(spwny, 'invoke').returns stream.PassThrough()
      command.init null, { cmd: 'test' }, events: subscribe: ->
      spwny.invoke.calledWith('test').should.be.ok

    it 'should die if spwny returns no stream', sinon.test ->
      @stub spwny, 'invoke'
      @stub process, 'exit'
      command.init null, { cmd: 'test' }, events: subscribe: ->
      process.exit.calledWith(1).should.be.ok

    it 'should trigger #pipe on each given module', sinon.test ->
      initSpy           = sinon.spy()
      passThroughStream = stream.PassThrough()
      @stub(spwny, 'invoke').returns passThroughStream
      command.init null, { cmd: 'test' }, modules : [ pipe : initSpy ], events: subscribe: ->
      initSpy.calledWith(passThroughStream).should.be.ok

    it 'should call #bindEvents', sinon.test ->
      @stub(spwny, 'invoke').returns stream.PassThrough()
      @stub command, 'bindEvents'
      command.init null, { cmd: 'test' }, modules : [], events: subscribe: ->
      command.bindEvents.called.should.be.ok
