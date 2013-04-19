define [
  'Handlebars'
  'jquery'
], (
  Handlebars
  $
) ->

  Handlebars.registerHelper 'statusSelected', (context, test) ->

    res = ''
    for i in context
      option = '<option value="' + i + '"'
      if test.toLowerCase() == i.toLowerCase()
        option += ' selected="selected"'
      option += '>'+ Handlebars.Utils.escapeExpression(i) + '</option>'
      res = res + option

    final = new Handlebars.SafeString res
    return final
