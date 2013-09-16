path = require 'path'
fs = require 'fs'
transformers = require 'transformers'

# markup
jade = transformers['jade']
stylus = transformers['stylus']
coffee = transformers['coffee']
uglify_js = transformers['uglify-js']
uglify_css = transformers['uglify-css']
uglify_html = require('html-minifier').minify

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
    rendered_jade = jade.renderFileSync @html_template,
      slides: @markdown_contents
      transition: @config.transition || 'slide'
      css: render_css.call(@)
      js: render_js.call(@)

    uglify_html rendered_jade,
      collapseWhitespace: true
      removeIgnored: true
      removeComments: true
      collapseBooleanAttributes: true

  render_css = ->
    uglify_css.renderSync(stylus.renderFileSync(@css_template))

  render_js = ->
    uglify_js.renderSync(coffee.renderFileSync(@js_template))

module.exports = HTMLRenderer
