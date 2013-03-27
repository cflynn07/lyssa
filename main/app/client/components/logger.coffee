define [], () ->
  history = []
  (logArgs) ->
    history.push
      logArgs: logArgs
      time: Date.now()
    if console.log?
      console.log logArgs