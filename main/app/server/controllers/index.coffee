async          = require 'async'
html_minifier  = require 'html-minifier'

module.exports = (req, res) ->

  async.map ['header', 'body', 'footer']
  , (item, callback) ->

    res.render item,
      environment: GLOBAL.app.settings.env
      asset_hash:  GLOBAL.asset_hash,
      (err, html) ->
        callback err, html

  , (err, results) ->

    html = results[1] + results[2]
    html = html_minifier.minify html,
      collapseWhitespace: true
      removeComments:     true
    #preseve comments in header
    head = html_minifier.minify results[0],
      collapseWhitespace: true
    html = head + html
    res.end html

