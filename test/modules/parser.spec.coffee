sinon  = require 'sinon'
parser = require "#{process.cwd()}/modules/parser"

describe 'parser', ->
  it 'should exist', -> parser.should.be.ok

  describe '#init', ->
    it 'should set parser as from config item', ->
      fn = 'hello'
      parser.init null, null, config : parser : fn
      parser.parserFn.should.equal fn

  describe '#pipe', ->
    it 'should not call stream pipe unless there is parserFn', ->
      stream = pipe : sinon.spy()
      parser.parserFn = null
      parser.pipe stream
      stream.pipe.called.should.not.be.ok

    it 'should call pipe if there is parserFn', ->
      stream = pipe : sinon.spy()
      parser.parserFn = ->
      parser.pipe stream
      stream.pipe.called.should.be.ok

    it 'should return stream unless there is parserFn', ->
      stream = pipe : ->
      parser.parserFn = null
      res = parser.pipe stream
      res.should.equal stream

    it 'should return stream if there is parserFn', ->
      stream = pipe : -> stream
      parser.parserFn = ->
      res = parser.pipe stream
      res.should.equal stream
