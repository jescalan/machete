class Slideshow

  constructor: (@el) ->
    define_jquery_extensions()
    @init()
    return { next: @next_slide, prev: @prev_slide }

  init: ->
    $(@el).children().addClass('future')
    $(@el).children().first().currentSlide()
    @state = 1
    @total_slides = $(@el).children().length
    pin_slides.call(@)
    setup_keyboard_triggers.call(@)
    setup_state_reader.call(@)
    @animation_hook()

  next_slide: ->
    $(@el).find('.current').next_loop().currentSlide()
    @animation_hook()
    push_state.call(@)

  prev_slide: ->
    $(@el).find('.current').prev_loop().currentSlide()
    @animation_hook()
    pop_state.call(@)

  go_to: (num) ->
    if num > @total_slides then return
    @state = num || 1
    $($(@el).children()[@state-1]).currentSlide()
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
        when 32 then @next_slide() # space
        when 39 then @next_slide() # right arrow
        when 37 then @prev_slide() # left arrow

  pin_slides = ->
    for s in $(@el).children()
      if $(s).has('h3').length then $(s).addClass('pinned')

  setup_state_reader = ->
    window.onpopstate = => @go_to(read_state())

  read_state = ->
    url = document.createElement 'a'
    url.href = window.location.href
    parseInt(url.hash.slice(1))

  push_state = ->
    if !history.pushState then return
    if @state + 1 > @total_slides then @state = 1 else @state++
    history.pushState({ slide: @state }, '', "##{@state}")

  pop_state = ->
    if !history.pushState then return
    if @state - 1 < 1 then @state = @total_slides else @state--
    history.pushState({ slide: @state }, '', "##{@state}")
