'use strict'

describe 'Controller: FilterCtrl', ->

  # load the controller's module
  beforeEach module 'marketplaceApp'

  FilterCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    FilterCtrl = $controller 'FilterCtrl', {
      $scope: scope
    }

  it 'should create $scope.filterSelected when calling setFilter()', ->
    expect(scope.filterSelected).toBeUndefined()
    scope.setFilter()
    expect(scope.filterSelected).toEqual('categories')
