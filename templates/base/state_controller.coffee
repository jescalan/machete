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

  disabled = -> !history.pushState || !mch_ctx.history_enabled
