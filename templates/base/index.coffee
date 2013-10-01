#= require 'code_highlighter'
#= require 'keyboard_triggers'
#= require 'slide_processor'
#= require 'state_controller'
#= require 'mobile_handler'
#= require 'transition'

#= require 'transitions/slide'

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
    @mobile = new MobileHandler(@)

    # arrow controls
    $('#controls .left').on 'click', => @prev_slide()
    $('#controls .right').on 'click', => @next_slide()

    # misc setup functions
    @processor.pin_slides()
    @transition.hook()

    # return public api
    return @

  next_slide: ->
    @current().next_loop().currentSlide()
    @transition.hook()
    @state.push()

  prev_slide: ->
    @current().prev_loop().currentSlide()
    @transition.hook()
    @state.pop()

  go_to: (num) ->
    if num > @total_slides then return
    @state.current = num
    $($(@el).children()[@state.current-1]).currentSlide()
    @transition.hook()

  current: ->
    $(@el).find('.current')

  #
  # @api private
  #

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
