'use strict'

app.controller 'ModalCtrl', ($scope, $modalInstance, title, message, labelOk, labelCancel, theId) ->
  $scope.title = title
  $scope.message = message
  $scope.labelOk = labelOk
  $scope.labelCancel = labelCancel
  $scope.modalConfirm = ->
    $modalInstance.close(true)
    return
  $scope.modalCancel = ->
    $modalInstance.close(false)
    return

app.controller 'ModalRegionCtrl', ($scope, $modalInstance, title, message, regions, labelOk, labelCancel) ->
  $scope.title = title
  $scope.message = message
  $scope.labelOk = labelOk
  $scope.labelCancel = labelCancel
  $scope.regions = regions
  $scope.modalConfirm = ->
    $modalInstance.close(true)
    return
  $scope.modalCancel = ->
    $modalInstance.close(false)
    return
