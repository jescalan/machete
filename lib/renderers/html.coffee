path = require 'path'
fs = require 'fs'
transformers = require 'transformers'
color_converter = require '../util/colors'
colors = require 'colors'
Snockets = require 'snockets'

# markup
jade = transformers['jade']
stylus = require 'stylus'
axis = require 'axis-css'
coffee = transformers['coffee']
uglify_html = require('html-minifier').minify

# markdown
rs = require 'robotskirt'
parser = new rs.Markdown.std([rs.EXT_TABLES, rs.EXT_AUTOLINK])

# custom snockets compiler
Snockets.compilers.coffee.compileSync = (source_path) ->
  coffee.renderFileSync(source_path, { bare: true })
snockets = new Snockets

class HTMLRenderer

  # add option to minify or not?
  constructor: (@config, files) ->
    base_path = path.join(__dirname, "../../templates/#{@config.template || 'dark'}")
    @base_js_path = path.join(__dirname, '../../templates/base/index.coffee')
    @html_template = path.join(base_path, 'index.jade')
    @css_template = path.join(base_path, 'style.styl')
    @js_template = path.join(base_path, 'script.coffee')

    file_contents = files.map((f) -> fs.readFileSync(f, 'utf8'))
    @markdown_contents = file_contents.map((c) -> parser.render(c))

  render: ->

    process.stdout.write 'generating... '.grey

    rendered_jade = jade.renderFileSync @html_template,
      slides: @markdown_contents
      css: render_css.call(@)
      js: render_js.call(@)
      title: @config.title || 'Slide Deck'
      author: @config.author || 'Machete'
      transition: @config.transition || 'slide'

    output = uglify_html rendered_jade,
      collapseWhitespace: true
      removeIgnored: true
      removeComments: true
      collapseBooleanAttributes: true

    console.log 'done!'.green

    return output

  #
  # @api private
  #

  render_css = ->
    primary_color = to_stylus(@config.primary_color) || to_stylus('#292929')
    secondary_color = to_stylus(@config.secondary_color) || to_stylus('#F0B963')

    output = stylus(fs.readFileSync(@css_template, 'utf8'))
      .set('filename', @css_template)
      .define('primary', primary_color)
      .define('secondary', secondary_color)
      .use(axis({implicit: false}))
      .render()

    transformers['uglify-css'].renderSync(output)

    # eventually, this will be cleaned up and look as below
    # issue ref: https://github.com/ForbesLindesay/transformers/issues/23
    #
    # transformers.stylus.renderFileSync @css_template,
    #   use: axis({ implicit: false })
    #   define: { primary: primary_color, secondary: secondary_color }
    #   minify: true

  to_stylus = (color) ->
    c = color_converter.to_rgba_array(color)
    if !c then false else new stylus.nodes.RGBA(c[0], c[1], c[2], c[3])

  render_js = ->
    history_enabled = default_var(@config.history, true)
    touch_enabled = default_var(@config.mobile, true)

    output = "function MacheteContext(){" +
      # configuration variables
      include_variable('history_enabled', history_enabled) +
      include_variable('touch_enabled', touch_enabled) +
      # base js
      snockets.getConcatenation(@base_js_path, { minify: true, async: false }) + ";" +
      # theme js
      coffee.renderFileSync(@js_template, { bare: true }) +
      "}; mch_ctx = new MacheteContext;"

    transformers['uglify-js'].renderSync(output)

  include_variable = (name, v) ->
    "this.#{name} = #{v};"

  default_var = (_var, _default) ->
    if typeof _var != 'undefined' then _var else _default

module.exports = HTMLRenderer
