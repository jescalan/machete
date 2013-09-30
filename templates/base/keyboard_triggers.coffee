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
