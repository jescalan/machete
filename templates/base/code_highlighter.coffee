class CodeHighlighter

  # TODO: load hljs if not present
  # TODO: this should take options to define stylesheet, etc
  constructor: (@slideshow) ->
    if hljs then hljs.initHighlightingOnLoad()
