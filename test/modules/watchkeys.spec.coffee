sinon     = require 'sinon'
watchkeys = require "#{process.cwd()}/modules/watchkeys"

describe 'watchkeys', ->
  sandbox = null

  # Lets stub out methods that can potentially screw us over
  beforeEach ->
    sandbox = sinon.sandbox.create()
    sandbox.stub process.stdin, 'setRawMode'
    sandbox.stub process.stdin, 'resume'

  afterEach ->
    sandbox?.restore()

  describe '#args', ->
    it 'should have runOnce arg', -> watchkeys.args.runOnce.should.be.ok

  describe '#bindEvents', ->
    it 'should subscribe to keypress:ctrl:c event', ->
      events = subscribe : sinon.spy()
      watchkeys.bindEvents events
      events.subscribe.calledWith 'keypress:ctrl:c'

    it 'should trigger process pause when triggered', sinon.test ->
      @stub process.stdin, 'pause'
      events = subscribe : (evt, cb) -> cb()
      watchkeys.bindEvents events
      process.stdin.pause.called.should.be.ok

  describe '#getEventName', ->
    it 'should exist', -> watchkeys.getEventName.should.be.ok

    it 'should return keypress event for a single keypress', ->
      watchkeys.getEventName(name: 'r').should.eql 'keypress:r'

    it 'should return keypress event with modifier for a single keypress', ->
      watchkeys.getEventName(name: 'r', ctrl: true).should.eql 'keypress:ctrl:r'

    it 'should return keypress event with modifier for a single keypress, filtering ONLY true keywords', ->
      watchkeys.getEventName(name: 'r', ctrl: 'test').should.eql 'keypress:r'

    it 'should return keypress event with multiple modifiers for a single keypress', ->
      watchkeys.getEventName(name: 'r', ctrl: true, shift: true).should.eql 'keypress:ctrl:shift:r'

    it 'should return keypress event with multiple modifiers for a single keypress, ignoring false ones', ->
      watchkeys.getEventName(name: 'r', ctrl: false, shift: true).should.eql 'keypress:shift:r'

  describe '#init', ->
    it 'should not start watching if runOnce is passed', sinon.test ->
      @stub process.stdin, 'on'
      watchkeys.init null, { runOnce: true }, null
      process.stdin.on.called.should.not.be.ok

    it 'should call #bindEvents', sinon.test ->
      @stub watchkeys, 'bindEvents'
      watchkeys.init()
