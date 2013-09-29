class Slideshow

  constructor: (@el, TransitionClass) ->
    # general prep
    inject_vendor_scripts()
    define_jquery_extensions()

    # set up the slide classes
    $(@el).children().addClass('future')
    $(@el).children().first().currentSlide()
    @total_slides = $(@el).children().length

    # set up the transition type
    transition_name = $(@el).attr('class').split(' ')[0]
    TransitionClass ?= mch_ctx["#{titleCase(transition_name)}Transition"]

    # set up everything else
    @state = new StateController(@)
    @processor = new SlideProcessor(@)
    @transition = new TransitionClass(@)
    @triggers = new KeyboardTriggers(@)
    @highlighter = new CodeHighlighter(@)

    # misc setup functions
    @processor.pin_slides()
    @transition.hook()

    # return public api
    return { next: @next_slide, prev: @prev_slide, current: $(@el).find('.current') }

  next_slide: ->
    $(@el).find('.current').next_loop().currentSlide()
    @transition.hook()
    @state.push()

  prev_slide: ->
    $(@el).find('.current').prev_loop().currentSlide()
    @transition.hook()
    @state.pop()

  go_to: (num) ->
    if num > @total_slides then return
    @state.current = num
    $($(@el).children()[@state.current-1]).currentSlide()
    @transition.hook()

  # @api private

  titleCase = (str) ->
    str.replace(/\w\S*/g, (t) -> t.charAt(0).toUpperCase() + t.substr(1).toLowerCase())

  inject_vendor_scripts = ->
    # make sure jquery, hammer, etc. are present

  define_jquery_extensions = ->

    $.fn.currentSlide = ->
      @removeClass('past future').addClass 'current'
      @prevAll().removeClass('current future').addClass 'past'
      @nextAll().removeClass('current past').addClass 'future'

    $.fn.next_loop = ->
      $next = @next()
      return $next if $next.length
      @siblings().first()

    $.fn.prev_loop = ->
      $prev = @prev()
      return $prev if $prev.length
      @siblings().last()

#
# handles animation between slides
#

class @Transition

  constructor: (@slideshow) ->
    @el = $(@slideshow.el)

  hook: ->
    if !@el.hasClass('loaded') then setTimeout (=> @el.addClass('loaded')), 1

#
# slide transition
#

class @SlideTransition extends @Transition

  hook: ->
    slide_width = $(@el).children().width()
    $(@el).find('.future').css(left: window.innerWidth + slide_width)
    $(@el).find('.past').css(left: -window.innerWidth - slide_width)
    $(@el).find('.current').css(left: 0)
    super()

#
# sets up and configures code highlighting
#

class CodeHighlighter

  # TODO: load hljs if not present
  # TODO: this should take options to define stylesheet, etc
  constructor: (@slideshow) ->
    if hljs then hljs.initHighlightingOnLoad()

#
# processes slides, applies special treatment to special types
#

class SlideProcessor
  constructor: (@slideshow) ->

  pin_slides: ->
    for s in $(@slideshow.el).children()
      if $(s).has('h3').length then $(s).addClass('pinned')

#
# binds key presses to actions
#

class KeyboardTriggers
  constructor: (@slideshow) ->
    $(window).on 'keydown', (e) =>
      switch e.keyCode
        when 32 then space.call(@)
        when 39 then right_arrow.call(@)
        when 37 then left_arrow.call(@)

  # @api private

  space = -> @slideshow.next_slide()
  left_arrow = -> @slideshow.prev_slide()
  right_arrow = -> @slideshow.next_slide()

#
# maps between the URL and slideshow
#

class StateController
  constructor: (@slideshow) ->
    url = document.createElement 'a'
    url.href = window.location.href
    @current = parseInt(url.hash.slice(1)) || 1
    window.onpopstate = => @slideshow.go_to(@current)

  push: ->
    if disabled() then return
    if @current + 1 > @slideshow.total_slides then @current = 1 else @current++
    history.pushState({ slide: @current }, '', "##{@current}")

  pop: ->
    if disabled() then return
    if @current - 1 < 1 then @current = @slideshow.total_slides else @current--
    history.pushState({ slide: @current }, '', "##{@current}")

  # @api private

  disabled = -> !history.pushState || !history_enabled
