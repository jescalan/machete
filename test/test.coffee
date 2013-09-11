should = require 'should'
Machete = require '../lib'
path = require 'path'
fs = require 'fs'

test_dir = path.resolve('test/slides')
output_path = path.join(test_dir, 'slideshow.html')
machete = new Machete(test_dir)

describe 'basic', ->

  before -> machete.generate()

  it 'should generate output file', ->
    fs.existsSync(output_path).should.be.ok

  it 'should contain compiled markdown', ->
    contents = fs.readFileSync(output_path, 'utf8')
    contents.should.match /Introduction/
    contents.should.match /Slide Two/
    contents.should.match /Slide Three/

  it 'should include the css', ->
    contents = fs.readFileSync(output_path, 'utf8')
    contents.should.match /<style type="text\/css">/

  it 'should include the javascript', ->
    contents = fs.readFileSync(output_path, 'utf8')
    contents.should.match /<script type="text\/javascript">/

  after -> fs.unlinkSync(output_path)
