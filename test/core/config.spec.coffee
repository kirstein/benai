sinon  = require 'sinon'
path   = require 'path'
fs     = require 'fs'
config = require "#{process.cwd()}/core/config"

describe 'config', ->

  describe 'load', ->
    it 'should have set load to false', -> config.load.should.eql false

  describe 'args', ->
    it 'should have config', -> config.args.config.should.be.ok

  describe '#init', ->
    it 'should exist', -> config.init.should.be.ok
    it 'should trigger loadConfig when config is added and exists', sinon.test ->
      @stub(fs, 'existsSync').returns true
      @stub config, 'loadConfigs'
      config.init null, config: 'test'
      config.loadConfigs.calledWith('test').should.be.ok

    it 'should check for config url in PWD if its not defined', sinon.test ->
      @stub(fs, 'existsSync').returns false
      config.init()
      fs.existsSync.calledWith(path.join process.cwd(), 'benai.conf.js').should.be.ok

    it 'should not trigger loadConfig when the general config file does not exist', sinon.test ->
      @stub(fs, 'existsSync').returns false
      @stub config, 'loadConfigs'
      config.init()
      config.loadConfigs.called.should.not.be.ok

  describe '#loadConfigs', ->
    it 'should exist', -> config.loadConfigs.should.be.ok

    it 'should try to require the config file', ->
