###
#  Verify access credentials
###

module.exports = (req, res, next, router) ->

  if req.requestType is 'http'

    ## Token or session based authentication?
    if !req.session.user?
      res.jsonAPIRespond
        error: 'Unauthorized'
        code: 401
    else
      #applyAuthBadge(req)
      callback()

  else if req.requestType is 'socketio'

    ## Session based authentication
    if !req.session.user?
      res.jsonAPIRespond
        error: 'Unauthorized'
        code: 401
    else
      #applyAuthBadge(req)
      callback()
