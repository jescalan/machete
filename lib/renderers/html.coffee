rs = require 'robotskirt'
parser = new rs.Markdown.std([rs.EXT_TABLES, rs.EXT_AUTOLINK])
jade = require 'jade'
path = require 'path'
fs = require 'fs'

class HTMLRenderer

  constructor: (@config, files) ->
    @template = path.resolve("templates/#{@config.template || 'dark'}/index.jade")
    @file_contents = files.map((f) -> fs.readFileSync(f, 'utf8'))
    @markdown_contents = @file_contents.map((c) -> parser.render(c))

  render: ->
    jade_fn = jade.compile(fs.readFileSync(@template, 'utf8'), filename: @template, pretty: true)
    jade_fn
      slides: @markdown_contents
      transition: @config.transition || 'slide'

module.exports = HTMLRenderer
