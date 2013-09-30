class @SlideTransition extends @Transition

  hook: ->
    slide_width = $(@el).children().width()
    $(@el).find('.future').css(left: window.innerWidth + slide_width)
    $(@el).find('.past').css(left: -window.innerWidth - slide_width)
    $(@el).find('.current').css(left: 0)
    super()
