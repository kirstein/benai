fs    = require 'fs'
mod   = require "#{process.cwd()}/lib/modules"
sinon = require 'sinon'

describe 'modules', ->
  describe '#load', ->

    it 'should readdir', sinon.test ->
      @stub fs, 'readdirSync'
      mod.load 'folder'
      fs.readdirSync.called.should.be.ok

  describe '#sortModulesByPriority', ->
    it 'should sort given array by priority', ->
      res = mod.sortModulesByPriority [ { priority: 2}, { priority: 1}]
      res[0].priority.should.eql 1

    it 'should count no priority as priority 1', ->
      res = mod.sortModulesByPriority [ { }, { priority: 0 }]
      res[0].priority.should.eql 0

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

    it 'should initiate the modules in their order, according to priorty setting', ->
      dummy1 = init : sinon.spy(), priority: 0
      dummy2 = init : sinon.spy(), priority: 6
      dummy3 = init : sinon.spy(), priority: 3
      mod.init [ dummy1, dummy2, dummy3 ]
      sinon.assert.callOrder dummy1.init, dummy3.init, dummy2.init

    it 'should set default priority as 1 if no priority is set', ->
      dummy1 = init : sinon.spy(), priority: 0
      dummy2 = init : sinon.spy()
      dummy3 = init : sinon.spy(), priority: 3
      mod.init [ dummy1, dummy3, dummy2 ]
      sinon.assert.callOrder dummy1.init, dummy2.init, dummy3.init

    it 'should initiate the modules with higher priority last', ->
      dummy1 = init : sinon.spy(), priority: 999
      dummy2 = init : sinon.spy()
      mod.init [ dummy1, dummy2 ]
      sinon.assert.callOrder dummy2.init, dummy1.init


