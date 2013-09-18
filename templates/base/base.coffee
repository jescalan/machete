class Slideshow

  constructor: (@el) ->
    define_jquery_extensions()
    @init()
    return { next: @next_slide, prev: @prev_slide }

  init: ->
    $(@el).children().addClass('future')
    $(@el).children().first().currentSlide()
    pin_slides.call(@)
    setup_keyboard_triggers.call(@)
    @animation_hook()

  next_slide: ->
    $(@el).find('.current').next_loop().currentSlide()
    @animation_hook()

  prev_slide: ->
    $(@el).find('.current').prev_loop().currentSlide()
    @animation_hook()

  animation_hook: ->
    transition_name = $(@el).attr('class').split(' ')[0]
    @["#{transition_name}_hook"]() if @["#{transition_name}_hook"]
    setTimeout (=> $(@el).addClass('loaded')), 1

  # animation types

  slide_hook: ->
    slide_width = $(@el).children().width()
    $(@el).find('.future').css(left: window.innerWidth + slide_width)
    $(@el).find('.past').css(left: -window.innerWidth - slide_width)
    $(@el).find('.current').css(left: 0)

  # @api private

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

  setup_keyboard_triggers = ->
    $(window).on 'keydown', (e) =>
      switch e.keyCode
        when 39 then @next_slide()
        when 37 then @prev_slide()

  pin_slides = ->
    for s in $(@el).children()
      if $(s).has('h3').length then $(s).addClass('pinned')
