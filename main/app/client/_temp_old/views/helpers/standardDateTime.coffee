define 'views/helpers/standardDateTime',
[
  'Handlebars'
  'jquery'
  'jqueryDateFormat'
], (
  Handlebars
  $
  $df
) ->

  standardDateTime = (context, options) ->
    d = new Date(context)
    split = d.toString().split(" ")
    timeZoneFormatted = split[split.length - 2] + " " + split[split.length - 1]
    $.format.date(d.getTime(), 'MM/dd/yyyy hh:mm:ss') + ' ' + timeZoneFormatted

  Handlebars.registerHelper 'standardDateTime', standardDateTime

  return standardDateTime