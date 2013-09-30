class SlideProcessor
  constructor: (@slideshow) ->

  pin_slides: ->
    for s in $(@slideshow.el).children()
      if $(s).has('h3').length then $(s).addClass('pinned')
