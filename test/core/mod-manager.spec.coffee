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

    it 'should not exclude anything if exclude is missing', ->
      modules = [ name: 'test' ]
      mod.init null, null, { modules }
      modules.length.should.eql 1

    it 'should not exclude anything if exclude is empty string', ->
      modules = [ name: 'test' ]
      mod.init null, exclude: '', { modules }
      modules.length.should.eql 1

    it 'should exclude modules whos name match the exclude string (as list)', ->
      modules = [ { name: 'test2' }, { name: 'test1' } ]
      mod.init null, { exclude: 'test1,test2' }, { modules }
      modules.length.should.eql 0

    it 'should not exclude anything if exclude is missing', ->
      modules = [ name: 'test' ]
      mod.init null, null, { modules }
      modules.length.should.eql 1

    it 'should not exclude anything if the exclude list is empty aray', ->
      modules = [ { name: 'test2' }, { name: 'test1' } ]
      exclude = []
      mod.init null, null, { modules, config: { exclude } }
      modules.length.should.eql 2

    it 'should exclude one module from config string', ->
      modules = [ { name: 'test2' }, { name: 'test1' } ]
      exclude = 'test2'
      mod.init null, null, { modules, config: { exclude } }
      modules.length.should.eql 1

    it 'should exclude one module from config list (e01)', ->
      modules = [ { name: 'test2' }, { name: 'test1' } ]
      exclude = [ 'test2' ]
      mod.init null, null, { modules, config: { exclude } }
      modules.length.should.eql 1

    it 'should exclude multiple modules from config list', ->
      modules = [ { name: 'test2' }, { name: 'test1' } ]
      exclude = [ 'test2', 'test1' ]
      mod.init null, null, { modules, config: { exclude } }
      modules.length.should.eql 0

