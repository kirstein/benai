sinon   = require 'sinon'
commons = require "#{process.cwd()}/lib/commons"

describe 'commons', ->
  describe '#die', ->
    it 'should write a message to stdout', sinon.test ->
      @stub process, 'exit'
      @stub process.stdout, 'write'
      commons.die 'message'
      process.stdout.write.calledWith('message').should.be.ok

    it 'should not write a message if there is none to write', sinon.test ->
      @stub process, 'exit'
      @stub process.stdout, 'write'
      commons.die()
      process.stdout.write.called.should.not.be.ok

    it 'should trigger process exit with default code of 1', sinon.test ->
      @stub process, 'exit'
      @stub process.stdout, 'write'
      commons.die()
      process.exit.calledWith(1).should.be.ok

    it 'should trigger process exit with given code', sinon.test ->
      @stub process, 'exit'
      @stub process.stdout, 'write'
      commons.die null, 20
      process.exit.calledWith(20).should.be.ok

