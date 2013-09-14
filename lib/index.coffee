fs = require 'fs'
path = require 'path'
yaml = require 'js-yaml'
HTMLRenderer = require './renderers/html'

class Machete

  constructor: (dir) ->
    @dir = dir || process.cwd()
    @config = require path.join(@dir, 'config.yml')
    @output_path = if @config.output_path then path.join(@dir, @config.output_path) else path.join(@dir, 'slideshow.html')

  generate: ->
    slide_files = fs.readdirSync(@dir)
                    .filter((f) -> path.extname(f) == '.md')
                    .map((f) => path.join(@dir, f))
    html_renderer = new HTMLRenderer(@config, slide_files)
    fs.writeFileSync @output_path, html_renderer.render()


module.exports = Machete

