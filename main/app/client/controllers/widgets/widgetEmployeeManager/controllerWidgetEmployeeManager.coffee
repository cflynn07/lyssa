define [
  'jquery'
  'angular'
  'angular-ui'
  'bootstrapFileUpload'
  'bootstrap'
  'underscore'
  'text!views/widgetEmployeeManager/viewWidgetEmployeeManager.html'
], (
  $
  angular
  angularUi
  bootstrapFileUpload
  bootstrap
  _
  viewWidgetEmployeeManager
) ->
  (Module) ->

    Module.run ['$templateCache', ($templateCache) ->
      $templateCache.put 'viewWidgetEmployeeManager', viewWidgetEmployeeManager
    ]


    Module.controller 'ControllerWidgetEmployeeManagerUpload', ['$scope',
    ($scope) ->

      $scope.csvUsersResult = []

      $scope.uploadComplete = (e, response) ->
        console.log 'done callback'
        console.log arguments
        if response == 'success'
          console.log JSON.parse e.responseText
          $scope.csvUsersResult = JSON.parse e.responseText

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
              apiRequest.post 'employee', {
                firstName: viewModel.newEmployeeManualAddForm.firstName
                lastName:  viewModel.newEmployeeManualAddForm.lastName
                email:     viewModel.newEmployeeManualAddForm.email
                phone:     viewModel.newEmployeeManualAddForm.phone
              }, (response) ->
                console.log response
              resetHelper()

            employees: {}
            employeeListDT:
              options:
                bStateSave:      true
                iCookieDuration: 2419200 # 1 month
                bJQueryUI:       true
                bPaginate:       true
                bLengthChange:   true
                bFilter:         true
                bInfo:           true
                bDestroy:        true
              columnDefs: [
                mData: null
                aTargets: [0]
                mRender: (data, type, full) ->
                  return '<span data-ng-bind="resourcePool[\'' + full.uid + '\'].firstName">' + full.firstName + '</span>'
              ,
                mData: null
                aTargets: [1]
                mRender: (data, type, full) ->
                  return '<span data-ng-bind="resourcePool[\'' + full.uid + '\'].lastName">' + full.lastName + '</span>'
              ,
                mData: null
                aTargets: [2]
                mRender: (data, type, full) ->
                  return '<span data-ng-bind="resourcePool[\'' + full.uid + '\'].email">' + full.email + '</span>'
              ,
                mData: null
                aTargets: [3]
                mRender: (data, type, full) ->
                  return '<span data-ng-bind="resourcePool[\'' + full.uid + '\'].phone">' + full.phone + '</span>'
              ,
                mData: null
                aTargets: [4]
                mRender: (data, type, full) ->
                  return '<span data-ng-bind="resourcePool[\'' + full.uid + '\'].username">' + full.username + '</span>'
              ,
                mData: null
                aTargets: [5]
                mRender: (data, type, full) ->
                  return '<span>***</span>'
              ,
                mData: null
                aTargets: [6]
                mRender: (data, type, full) ->
                  return '<span data-ng-bind="resourcePool[\'' + full.uid + '\'].type">' + full.type + '</span>'
              ]


          apiRequest.get 'employee', [], {}, (response) ->
            viewModel.employees = response.response

          $scope.viewModel = viewModel

      ]

