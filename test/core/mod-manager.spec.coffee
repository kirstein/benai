mod = require "#{process.cwd()}/core/mod-manager"

describe 'mod-manager', ->
  describe 'setup', ->
    it 'should have exclude arg', -> mod.args.exclude.should.be.ok
    it 'should have priority of 0', -> mod.priority.should.eql 0

  describe '#init', ->
    it 'should exist', -> mod.init.should.be.ok

    it 'should exclude modules whos name match the exclude string', ->
      modules = [ name: 'test' ]
      mod.init null, exclude: 'test', { modules }
      modules.length.should.eql 0

    it 'should exclude modules whos name match the exclude string (as list)', ->
      modules = [ { name: 'test2' }, { name: 'test1' } ]
      mod.init null, { exclude: 'test1,test2' }, { modules }
      modules.length.should.eql 0
