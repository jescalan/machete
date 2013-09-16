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
    @contents.should.match /<style>html,/

  it 'should include the javascript', ->
    @contents.should.match /<script>\(function\(\) \{/

  # this should test with other config.yml files too
  it 'should accurately reflect different transitions', ->
    @contents.should.match /<div id="slides" class="slide/

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
