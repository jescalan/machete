fs = require 'fs'
path = require 'path'
yaml = require 'js-yaml'
HTMLRenderer = require './renderers/html'

class Machete

  constructor: (dir) ->
    @dir = dir || process.cwd()
    config_path = path.join(@dir, 'config.yml')
    @config = if fs.existsSync(config_path) then require(config_path) else {}
    @output_path = if @config.output_path then path.join(@dir, @config.output_path) else path.join(@dir, 'slideshow.html')

  generate: ->
    slide_files = fs.readdirSync(@dir)
                    .filter((f) -> path.extname(f) == '.md')
                    .map((f) => path.join(@dir, f))
    html_renderer = new HTMLRenderer(@config, slide_files)
    fs.writeFileSync @output_path, html_renderer.render()


module.exports = Machete

