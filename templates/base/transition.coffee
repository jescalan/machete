class @Transition

  constructor: (@slideshow) ->
    @el = $(@slideshow.el)

  hook: ->
    if !@el.hasClass('loaded') then setTimeout (=> @el.addClass('loaded')), 1
