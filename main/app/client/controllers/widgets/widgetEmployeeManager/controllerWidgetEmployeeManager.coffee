define [
  'jquery'
  'async'
  'ejs'
  'angular'
  'angular-ui'
  'bootstrapFileUpload'
  'bootstrap'
  'underscore'
  'cs!utils/utilBuildDTQuery'
  'text!views/widgetEmployeeManager/viewWidgetEmployeeManager.html'
  'text!views/widgetEmployeeManager/viewPartialEmployeeManagerAddManualForm.html'
  'text!views/widgetEmployeeManager/viewPartialEmployeeManagerAddCSVForm.html'
  'text!views/widgetEmployeeManager/viewPartialEmployeeManagerListButtonsEJS.html'
  'text!views/widgetEmployeeManager/viewPartialEmployeeManagerEditEmployeeEJS.html'
], (
  $
  async
  EJS
  angular
  angularUi
  bootstrapFileUpload
  bootstrap
  _
  utilBuildDTQuery
  viewWidgetEmployeeManager
  viewPartialEmployeeManagerAddManualForm
  viewPartialEmployeeManagerAddCSVForm
  viewPartialEmployeeManagerListButtonsEJS
  viewPartialEmployeeManagerEditEmployeeEJS
) ->
  (Module) ->

    Module.run ['$templateCache', ($templateCache) ->
      $templateCache.put 'viewWidgetEmployeeManager',               viewWidgetEmployeeManager
      $templateCache.put 'viewPartialEmployeeManagerAddManualForm', viewPartialEmployeeManagerAddManualForm
      $templateCache.put 'viewPartialEmployeeManagerAddCSVForm',    viewPartialEmployeeManagerAddCSVForm
    ]

    Module.controller 'ControllerWidgetEmployeeManagerCSVUpload', ['$scope', 'apiRequest',
    ($scope, apiRequest) ->









      $scope.viewModel =
        uploadComplete:            false
        csvUsersResult:            []
        currentProcessingIterator: 0
        currentProgressPercent:    0

        validCSV:        false
        processingUsers: false
        processNewUsers: () ->
          $scope.viewModel.processingUsers = true

          apiPostArr = []
          for item in $scope.viewModel.csvUsersResult
            apiPostArr.push {
              firstName: item[0]
              lastName:  item[1]
              email:     item[2]
              phone:     item[3]
            }

          d1 = Date.now()
          apiRequest.post 'employee', apiPostArr, {silent:true}, (response) ->
            console.log 'response'
            console.log response
            console.log Date.now() - d1


          ###
          async.mapLimit $scope.viewModel.csvUsersResult, 1, (item, callback) ->
            d1 = Date.now()
            apiRequest.post 'employee', {
              firstName: item[0]
              lastName:  item[1]
              email:     item[2]
              phone:     item[3]
            }, (response) ->

              $scope.viewModel.currentProcessingIterator++
              $scope.viewModel.currentProgressPercent = Math.floor(($scope.viewModel.currentProcessingIterator / $scope.viewModel.csvUsersResult.length) * 100)

              if !$scope.$$phase
                $scope.$apply()
              console.log Date.now() - d1
              callback()

          , (err, result) ->
            cosole.log 'done with all!'
          ###


      $scope.uploadStart = (e, response) ->
        console.log 'start'

      $scope.uploadComplete = (e, response) ->
        console.log 'complete'
        if response == 'success'
          $scope.viewModel.csvUsersResult = JSON.parse e.responseText
          $scope.viewModel.validCSV       = _.isArray $scope.viewModel.csvUsersResult
          $scope.viewModel.uploadComplete = true

    ]




    Module.controller 'ControllerWidgetEmployeeManager',
      ['$scope', '$route', '$routeParams', 'socket', 'apiRequest', '$filter', '$dialog',
        ($scope, $route, $routeParams, socket, apiRequest, $filter, $dialog) ->



          resetHelper = () ->
            viewModel.showAddNewEmployee = false
            viewModel.addNewEmployeeMode = false
            viewModel.newEmployeeManualAddForm = {}

          viewModel =
            showAddNewEmployee: false
            addNewEmployeeMode: false #Manual || CSV
            showAddNewEmployeeOpen: () ->
              resetHelper()
              viewModel.showAddNewEmployee = true
            showAddNewEmployeeClose: () ->
              resetHelper()
            showAddNewEmployeeSubmit: () ->
              $scope.viewModel.newEmployeeManualAddForm.submitting = true

              apiRequest.post 'employee', {
                firstName: viewModel.newEmployeeManualAddForm.firstName
                lastName:  viewModel.newEmployeeManualAddForm.lastName
                email:     viewModel.newEmployeeManualAddForm.email
                phone:     viewModel.newEmployeeManualAddForm.phone
              }, {}, (response) ->
                console.log 'finished'
                console.log response
                resetHelper()

            employees: {}
            employeeListDT:
              detailRow: (obj) ->
                #return new EJS({text: viewPartialEmployeeManagerEditEmployeeEJS}).render obj
                return '<div data-edit-employee data-client-orm-share="clientOrmShare" data-resource-pool="resourcePool" data-employee-uid="' + obj.uid + '"></div>'

              options:
                bProcessing:  true
                bStateSave:      true
                iCookieDuration: 2419200 # 1 month
                bPaginate:       true
                bLengthChange:   true
                bFilter:         true
                bInfo:           true
                bDestroy:        true
                bServerSide:     true
                sAjaxSource:     '/'
                fnServerData: (sSource, aoData, fnCallback, oSettings) ->
                  #return
                  query = utilBuildDTQuery ['firstName', 'lastName', 'email', 'phone'],
                                           ['firstName', 'lastName', 'email', 'phone'],
                                           oSettings

                  cacheResponse   = ''
                  oSettings.jqXHR = apiRequest.get 'employee', [], query, (response) ->
                    if response.code == 200

                      responseDataString = JSON.stringify(response.response)
                      if cacheResponse == responseDataString
                        return
                      cacheResponse = responseDataString
                      empArr = _.toArray response.response.data

                      fnCallback
                        iTotalRecords:        response.response.length
                        iTotalDisplayRecords: response.response.length
                        aaData:               empArr

              columnDefs: [
                mData:     null
                bSortable: true
                aTargets:  [0]
                mRender: (data, type, full) ->
                  #console.log 'colrender1'
                  #console.log arguments
                  #return full.firstName
                  return '<span data-ng-bind="resourcePool[\'' + full.uid + '\'].firstName">' + full.firstName + '</span>'
              ,
                mData:     null
                bSortable: true
                aTargets:  [1]
                mRender: (data, type, full) ->
                  return '<span data-ng-bind="resourcePool[\'' + full.uid + '\'].lastName">' + full.lastName + '</span>'
              ,
                mData:     null
                bSortable: true
                aTargets:  [2]
                mRender: (data, type, full) ->
                  return '<span data-ng-bind="resourcePool[\'' + full.uid + '\'].email">' + full.email + '</span>'
              ,
                mData:     null
                bSortable: true
                aTargets:  [3]
                mRender: (data, type, full) ->
                  return '<span data-ng-bind="resourcePool[\'' + full.uid + '\'].phone | tel">' + full.phone + '</span>'
              ,
                mData:     null
                bSortable: false
                aTargets:  [4]
                mRender: (data, type, full) ->
                  return '' #<span data-ng-bind="resourcePool[\'' + full.uid + '\'].type">' + full.type + '</span>'
              ,
                mData:     null
                bSortable: false
                aTargets:  [5]
                mRender: (data, type, full) ->
                  return new EJS({text: viewPartialEmployeeManagerListButtonsEJS}).render(full)
              ]


          #apiRequest.get 'employee', [], {}, (response) ->
          #  viewModel.employees = response.response

          $scope.viewModel = viewModel

      ]

