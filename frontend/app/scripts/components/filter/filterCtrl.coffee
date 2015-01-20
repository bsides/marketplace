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
  advertisers,
  categories,
  weekdays,
  determinations,
  regions,
  makeFilter
  ) ->

  $scope.filterSelected = 'categories'
  $scope.setFilter = (filter) ->
    $scope.filterSelected = filter

  $scope.advertisers = advertisers
  $scope.categories = categories
  $scope.weekdays = weekdays
  $scope.determinations = determinations
  $scope.regions = regions

  $scope.ok = ->
    makeFilter()
    $scope.closeModal()
    return

  $scope.closeModal = ->
    $modalInstance.dismiss 'saiu'
    return
