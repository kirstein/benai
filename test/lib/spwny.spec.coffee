spwny  = require "#{process.cwd()}/lib/spwny"
cp     = require 'child_process'
sinon  = require 'sinon'

describe 'spwny', ->
  describe '#invoke', ->
    it 'should exist', -> spwny.invoke.should.be.ok

    it 'should throw when no cmd is defined', ->
      (-> spwny.invoke()).should.throw 'No command defined'

    it 'should spawn a child process', sinon.test ->
      @stub(cp, 'spawn').returns
        on: ->
        stdout: do -> pipe: ->

      spwny.invoke 'ls -la'
      cp.spawn.calledOnce.should.be.ok

    it 'should parse the arguments accordingly', sinon.test ->
      @stub(cp, 'spawn').returns
        on: ->
        stdout: do -> pipe: ->

      spwny.invoke 'ls -la'
      cp.spawn.args[0].should.eql [ 'ls', [ '-la' ]]

    it 'should trigger spawn multiple times if piping', sinon.test ->
      @stub(cp, 'spawn').returns
        on: ->
        stdout: do -> pipe: ->

      spwny.invoke 'ls -la | grep test'
      cp.spawn.calledTwice.should.be.ok
