fs = require 'fs'
path = require 'path'
rs = require 'robotskirt'
parser = new rs.Markdown.std([rs.EXT_TABLES, rs.EXT_AUTOLINK])
jade = require 'jade'
yaml = require 'js-yaml'

class Machete

  constructor: (dir) ->
    @dir = dir || process.cwd()
    @config = require path.join(@dir, 'config.yml')
    @template = path.resolve("templates/#{@config.template || 'dark'}/index.jade")
    @output_path = if @config.output_path then path.join(@dir, @config.output_path) else path.join(@dir, 'slideshow.html')

  generate: ->
    slide_files = fs.readdirSync(@dir).filter (f) -> path.extname(f) == '.md'

    rendered_slides = []
    for slide in slide_files
      content = fs.readFileSync(path.join(@dir, slide))
      rendered_slides.push parser.render(content)

    jade_fn = jade.compile(fs.readFileSync(@template, 'utf8'), filename: @template)
    html_output = jade_fn(slides: rendered_slides)
    fs.writeFileSync @output_path, html_output

# export
module.exports = Machete

