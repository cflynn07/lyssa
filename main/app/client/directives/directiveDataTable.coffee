define [
  'jquery'
  'datatables'
  'datatables_bootstrap'
], (
  $
  dataTables
  dataTables_bootstrap
) ->

  (Module) ->

    Module.directive "dataTable", ($compile) ->
      directive =
        restrict: 'A'
        scope: 'isolate'
        link: (scope, element, attrs) ->



          # apply DataTable options, use defaults if none specified by user
          options = {}
          if attrs.dataTable.length > 0
            options = scope.$eval(attrs.dataTable)
          else
            options =
              bStateSave: true
              iCookieDuration: 2419200 # 1 month
              bJQueryUI: true
              bPaginate: false
              bLengthChange: false
              bFilter: false
              bInfo: false
              bDestroy: true

          # Tell the dataTables plugin what columns to use
          # We can either derive them from the dom, or use setup from the controller
          explicitColumns = []
          element.find("th").each (index, elem) ->
            explicitColumns.push $(elem).text()

          if explicitColumns.length > 0
            options["aoColumns"] = explicitColumns
          else
            if attrs.aoColumns
              options["aoColumns"] = scope.$eval(attrs.aoColumns)


          # aoColumnDefs is dataTables way of providing fine control over column config
          if attrs.aoColumnDefs
            options["aoColumnDefs"] = scope.$eval(attrs.aoColumnDefs)
          if attrs.fnRowCallback
            options["fnRowCallback"] = scope.$eval(attrs.fnRowCallback)

          # apply the plugin
          dataTable = element.dataTable(options)

          # watch for any changes to our data, rebuild the DataTable
          scope.$watch attrs.aaData, (value) ->
            val = value or null
            if val

              convertedVal = []
              for propName, propVal of val
                if !propVal.deletedAt
                  convertedVal.push propVal

              dataTable.fnClearTable()
              dataTable.fnAddData convertedVal


              $compile(element.find('tr'))(scope)

          , true

