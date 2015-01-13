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
