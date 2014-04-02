sinon  = require 'sinon'
path   = require 'path'
fs     = require 'fs'
config = require "#{process.cwd()}/core/config"

describe 'config', ->

  describe 'args', ->
    it 'should have config', -> config.args.config.should.be.ok

  describe 'priority', ->
    it 'should have priority of -1', -> config.priority.should.eql -1

  describe '#findConfig', ->
    it 'should exist', -> config.findConfig.should.be.ok
    it 'should try to search for all different file types if there was nothing to be found', sinon.test ->
      @stub(fs, 'existsSync').returns false
      config.findConfig 'asd'
      fs.existsSync.callCount.should.eql 4

    it 'should skip searching if it has found one value', sinon.test ->
      @stub(fs, 'existsSync').returns true
      config.findConfig 'asd'
      fs.existsSync.calledOnce.should.be.ok

    it 'should check for config url in PWD if its not defined', sinon.test ->
      @stub(fs, 'existsSync').returns false
      config.findConfig 'my amazing config'
      fs.existsSync.calledWith('my amazing config').should.be.ok
      fs.existsSync.calledWith(path.join process.cwd(), 'benai.conf.cs').should.be.ok
      fs.existsSync.calledWith(path.join process.cwd(), 'benai.conf.coffee').should.be.ok
      fs.existsSync.calledWith(path.join process.cwd(), 'benai.conf.js').should.be.ok

  describe '#init', ->
    it 'should exist', -> config.init.should.be.ok
    it 'should trigger loadConfig when config is added and exists', sinon.test ->
      @stub(fs, 'existsSync').returns true
      @stub config, 'loadConfigs'
      config.init null, config: 'test'
      config.loadConfigs.calledWith('test').should.be.ok

    it 'should not trigger loadConfig when the general config file does not exist', sinon.test ->
      @stub(fs, 'existsSync').returns false
      @stub config, 'loadConfigs'
      config.init()
      config.loadConfigs.called.should.not.be.ok

    it 'should write config to opts if it does not exist', sinon.test ->
      @stub(fs, 'existsSync').returns true
      @stub config, 'loadConfigs'
      opts = {}
      config.init null, config: 'test', opts
      opts.config.should.be.ok

    it 'should extend the configs', sinon.test ->
      @stub(fs, 'existsSync').returns true
      @stub(config, 'loadConfigs').returns test: 123
      opts = {}
      config.init null, config: 'test', opts
      opts.config.test.should.be.eql 123

  describe '#loadConfigs', ->
    it 'should exist', -> config.loadConfigs.should.be.ok
