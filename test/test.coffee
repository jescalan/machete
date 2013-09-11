path = require 'path'
fs = require 'fs'
should = require 'should'
Machete = require '../lib'
Zombie = require 'zombie'

test_dir = path.resolve('test/slides')
output_path = path.join(test_dir, 'slideshow.html')
test_url = "file://#{output_path}"

machete = new Machete(test_dir)
browser = new Zombie()

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

describe 'javascript', ->

  window = null
  $ = null

  before (done) ->
    machete.generate()
    browser.visit(test_url).then(browser.wait.bind(browser)).then ->
      window = browser.document.window
      $ = window.jQuery
      done()

  it 'renders in the test browser', ->
    $('.slide:last').text().should.match /Introduction/

  it 'go to the next slide on right arrow', ->
    e = $.Event('keydown')
    e.keyCode = 39
    $(window).trigger(e)
    $('.slide:last').text().should.match /Slide Two/
