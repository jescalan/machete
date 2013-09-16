path = require 'path'
fs = require 'fs'
transformers = require 'transformers'

# markup
jade = transformers['jade']
stylus = require 'stylus'
axis = require 'axis-css'
coffee = transformers['coffee']
uglify_html = require('html-minifier').minify

# markdown
rs = require 'robotskirt'
parser = new rs.Markdown.std([rs.EXT_TABLES, rs.EXT_AUTOLINK])

class HTMLRenderer

  # add option to minify or not?
  constructor: (@config, files) ->
    base_path = path.resolve("templates/#{@config.template || 'dark'}")
    @html_template = path.join(base_path, 'index.jade')
    @css_template = path.join(base_path, 'style.styl')
    @base_js_template = path.resolve('templates/base/base.coffee')
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
    output = stylus(fs.readFileSync(@css_template, 'utf8'))
      .set('filename', @css_template)
      .use(axis())
      .render()
    transformers['uglify-css'].renderSync(output)

    # eventually, this will be cleaned up and look as below
    # issue ref: https://github.com/ForbesLindesay/transformers/issues/23
    #
    # transformers.stylus.renderFileSync @css_template,
    #   use: axis()
    #   minify: true

  render_js = ->
    output = "(function(){" +
    coffee.renderFileSync(@base_js_template, { bare: true }) +
    coffee.renderFileSync(@js_template, { bare: true }) +
    "}).call(this);"
    transformers['uglify-js'].renderSync(output)

module.exports = HTMLRenderer
