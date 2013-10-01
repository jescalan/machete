class MobileHandler

  constructor: (@slideshow) ->
    if mch_ctx.touch_enabled
      Hammer(window).on 'swiperight', => @slideshow.prev_slide()
      Hammer(window).on 'swipeleft', => @slideshow.next_slide()
