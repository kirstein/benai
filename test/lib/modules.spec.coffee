fs    = require 'fs'
mod   = require "#{process.cwd()}/lib/modules"
sinon = require 'sinon'

describe 'modules', ->
  describe '#load', ->

    it 'should readdir', sinon.test ->
      @stub fs, 'readdirSync'
      mod.load 'folder'
      fs.readdirSync.called.should.be.ok

  describe '#getArgs', ->

    it 'should filter out only args', ->
      args = test : 123
      res  = mod.getArgs [ { args, something: 'else' } ]
      res.should.eql args

    it 'should reduce multiple modules to one', ->
      res = mod.getArgs [ { args: test: 123 }, { args : one: 'two' } ]
      res.should.eql test: 123, one: 'two'

    it 'should combine multiple arrays to one', ->
      args = [ [ { args: test: 123 }, { args : one: 'two' } ], [ { args: two: 'one' } ] ]
      res  = mod.getArgs args...
      res.should.eql test: 123, one: 'two', two: 'one'

  describe '#init', ->

    it 'should trigger init method on one module', ->
      dummy = init : sinon.spy()
      mod.init [ dummy ]
      dummy.init.calledOnce.should.be.ok

    it 'should not throw if no init mehtod is available', ->
      (-> mod.init [ {} ]).should.not.throw()

    it 'should trigger init method on all modules if wrapped in array', ->
      dummy = init : sinon.spy()
      dummy2 = init : sinon.spy()
      mod.init [ [ dummy2 ], [ dummy ] ]
      dummy.init.calledOnce.should.be.ok
      dummy2.init.calledOnce.should.be.ok

    it 'should trigger init method on all modules', ->
      dummies = [ { init : sinon.spy() }, { init : sinon.spy() }, { init: sinon.spy() } ]
      mod.init dummies
      dummies.forEach (dummy) ->
        dummy.init.calledOnce.should.be.ok

    it 'should pass all the given arguments to init fn', ->
      dummy = init : sinon.spy()
      mod.init [ dummy ], 1, 2, 3
      dummy.init.calledWithExactly(1,2,3).should.be.ok
