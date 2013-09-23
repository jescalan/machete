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

  before ->
    machete.generate()
    @contents = fs.readFileSync(output_path, 'utf8')

  it 'should generate output file', ->
    fs.existsSync(output_path).should.be.ok

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

  it 'should accept primary color options'
  it 'should accept secondary color options'
  it 'should go to the correct slide according to the url hash'
  it 'should hash the url when going to the next slide'
  it 'should has the url when going to the previous slide'
  it 'should navigate correctly on forward and back buttons'

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
    $('.current').text().should.match /Introducing Machete/

  it 'go to the next slide on right arrow'
  it 'go to the previous slide on left arrow'

  after -> fs.unlinkSync(output_path)

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
