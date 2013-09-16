path = require 'path'
fs = require 'fs'
transformers = require 'transformers'

# markup
jade = transformers.jade
stylus = transformers.stylus
coffee = transformers.coffee

# markdown
rs = require 'robotskirt'
parser = new rs.Markdown.std([rs.EXT_TABLES, rs.EXT_AUTOLINK])

class HTMLRenderer

  constructor: (@config, files) ->
    base_path = path.resolve("templates/#{@config.template || 'dark'}")
    @html_template = path.join(base_path, 'index.jade')
    @css_template = path.join(base_path, 'style.styl')
    @js_template = path.join(base_path, 'script.coffee')

    file_contents = files.map((f) -> fs.readFileSync(f, 'utf8'))
    @markdown_contents = file_contents.map((c) -> parser.render(c))

  render: ->
    jade.renderFileSync @html_template,
      pretty: true
      slides: @markdown_contents
      transition: @config.transition || 'slide'
      css: render_css.call(@)
      js: render_js.call(@)

  render_css = ->
    stylus.renderFileSync(@css_template)

  render_js = ->
    coffee.renderFileSync(@js_template)

module.exports = HTMLRenderer
