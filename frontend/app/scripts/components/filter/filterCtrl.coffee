'use strict'

app.factory 'modalUtils', [
  '$modalStack'
  ($modalStack) ->
    return (
      modalsExist: ->
        !!$modalStack.getTop()

      closeAllModals: ->
        $modalStack.dismissAll()
        return
    )
]

app.controller 'FilterCtrl', (
  $scope,
  $modalInstance,
  $log,
  advertisers,
  categories,
  weekdays,
  determinations,
  regions,
  makeFilter,
  modalSelectedAdvertiser
  ) ->

  $scope.filterSelected = 'categories'
  $scope.setFilter = (filter) ->
    $scope.filterSelected = filter

  $scope.advertisers = advertisers
  $scope.categories = categories
  $scope.weekdays = weekdays
  $scope.determinations = determinations
  $scope.regions = regions
  $scope.modalSelectedAdvertiser = modalSelectedAdvertiser
  $scope.isAdvertiserSelectable = true if $scope.advertisers.length > 1

  $scope.ok = ->
    if $scope.formFilter.$valid
      makeFilter($scope.modalSelectedAdvertiser)
      $scope.closeModal()
    else
      $log.info $scope.formFilter.modalSelectedAdvertiserError
    return

  $scope.closeModal = ->
    $modalInstance.dismiss 'saiu'
    return
