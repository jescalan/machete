path = require 'path'
fs = require 'fs'
should = require 'should'
Machete = require '../lib'
Zombie = require 'zombie'
browser = new Zombie()

setup = (dir) ->
  root = path.resolve("test/#{dir}")
  @output = path.join(root, 'slideshow.html')
  (new Machete(root)).generate()
  @contents = fs.readFileSync(@output, 'utf8')

describe 'command line', ->

  it 'new command should work correctly'

describe 'basic', ->

  before -> setup.call(@, 'slides')

  it 'should generate output file', ->
    fs.existsSync(@output).should.be.ok

  it 'should contain compiled markdown', ->
    @contents.should.match /Introducing/
    @contents.should.match /Slide Two/
    @contents.should.match /Slide Three/

  it 'should include the css', ->
    @contents.should.match /<style>article,aside/

  it 'should include the javascript', ->
    @contents.should.match /<script>\(function\(\)\{/

  # this should test with other config.yml files too
  it 'should accurately reflect different transitions', ->
    @contents.should.match /<div id="slides" class="slide/

  after -> fs.unlinkSync(@output)

describe 'color configuration', ->

  before -> setup.call(@, 'colors')

  it 'should accept primary color options', ->
    @contents.should.match /#6f0000/

  it 'should accept secondary color options', ->
    @contents.should.match /#ffa500/

  after -> fs.unlinkSync(@output)

colors = require('../lib/util/colors')
describe 'color converter', ->

  it 'converts hex to rgba array', ->
    colors.to_rgba_array('#ff0000').should.eql [255,0,0,1]

  it 'converts shorthand hex to rgba array', ->
    colors.to_rgba_array('#f00').should.eql [255,0,0,1]

  it 'converts rgb to rgba array', ->
    colors.to_rgba_array('rgb(255,0,0)').should.eql [255,0,0,1]

  it 'converts rgba to rgba array', ->
    colors.to_rgba_array('rgba(255,0,0,1)').should.eql [255,0,0,1]

  it 'converts named color to rgba array', ->
    colors.to_rgba_array('red').should.eql [255,0,0,1]

describe 'javascript', ->
  window = null
  $ = null

  before (done) ->
    setup.call(@, 'slides')
    @test_url = "file://#{@output}"
    browser.visit(@test_url).then(browser.wait.bind(browser)).then ->
      window = browser.document.window
      $ = window.jQuery
      done()

  it 'renders in the test browser', ->
    $('.current').text().should.match /Introducing Machete/

  it 'go to the next slide on right arrow'
  it 'go to the previous slide on left arrow'
  it 'should go to the correct slide according to the url hash'
  it 'should hash the url when going to the next slide'
  it 'should has the url when going to the previous slide'
  it 'should navigate correctly on forward and back buttons'
  it 'should not use pushstate if history is false in config.yml'

  after -> fs.unlinkSync(@output)
