define 'views/helpers/standardDate',
[
  'Handlebars'
  'jquery'
  'jqueryDateFormat'
], (
  Handlebars
  $
  $df
) ->

  standardDate = (context, options) ->
    d = new Date(context)
    split = d.toString().split(" ")
    timeZoneFormatted = split[split.length - 2] + " " + split[split.length - 1]
    $.format.date(d.getTime(), 'MM/dd/yyyy') + ' ' + timeZoneFormatted

  Handlebars.registerHelper 'standardDate', standardDate
  return standardDate